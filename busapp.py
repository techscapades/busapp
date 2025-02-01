import time
import requests
from bs4 import BeautifulSoup
import json
import paho.mqtt.client as mqtt

# Scraping block
get_interval = 10
service_no = 324
bus_stop_no = 62251
bus_info = [{'bus_number': 324, 'bus_stop_number': 62251, 'comment': 'To Hougang Bus Interchange, BLK 471b'},
            {'bus_number': 102, 'bus_stop_number': 64409, 'comment': 'To Hougang Bus Interchange, BLK 477a'},
            {'bus_number': 62, 'bus_stop_number': 64409, 'comment': 'To Hougang Station Exit C, BLK 477a'},
            {'bus_number': 102, 'bus_stop_number': 64401, 'comment': 'To Buangkok Station, OPP BLK 477a'}]
scraped_data = []


def scrape_data(bus_num, bus_stop_num, bus_dir):
    try:
        # Send GET request to the webpage
        url = f"https://www.sbstransit.com.sg/service/sbs-transit-app?ServiceNo={bus_num}&BusStopNo={bus_stop_num}"
        response = requests.get(url)

        # Check if the request was successful
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')

            # Find the table with class "table tb-bus tbres tbbreak-app"
            table = soup.find('table', class_='table tb-bus tbres tbbreak-app')

            # Check if the table exists
            if table:
                # Extract the rows from the table
                rows = table.find_all('tr')

                # Print the header (optional, depending on the table)
                headers = rows[0].find_all('th')
                headers = [header.text.strip() for header in headers]
                # print("Headers:", headers)
                # Extract and print data from each row
                for row in rows[2:]:
                    columns = row.find_all('td')
                    data = [column.text.strip() for column in columns]
                    bus_stop_data = data[0].split('-')  # Split by '-' to get the bus stop number
                    bus_stop_nums = bus_stop_data[0].strip()  # Take only the first part
                    # Display data with only bus stop number and times
                    # print([bus_stop_nums, *data[1:]])
                    bus_stop_dict = {
                        'Bus': bus_num,
                        'Bus direction': bus_dir,
                        'Bus Stop': bus_stop_number,
                        'Next Bus': data[1],  # Next Bus time
                        'Subsequent Bus': data[2]  # Subsequent Bus time
                    }

                    # Add this dictionary to the list
                    scraped_data.append(bus_stop_dict)

            else:
                print("The specified table was not found.")

        else:
            print(f"Failed to retrieve page, status code: {response.status_code}")
    except Exception as e:
        print(f"An error occurred: {e}")


# mqtt block
def on_message(client, userdata, message):
    print(f"Message received on topic {message.topic}: {message.payload.decode()}")


use_mqtt = True
if use_mqtt:
    broker_address = "localhost"
    broker_port = 1883
    pub_topic = "bus/data/out"
    sub_topic = "bus/data/in"
    client = mqtt.Client()
    client.on_message = on_message
    client.connect(broker_address, broker_port, 60)
    client.subscribe(sub_topic)
    client.loop_start()

while True:
    # scraping block
    scraped_data = []
    for bus in bus_info:
        bus_number = bus['bus_number']
        bus_stop_number = bus['bus_stop_number']
        bus_direction = bus['comment']
        scrape_data(bus_number, bus_stop_number, bus_direction)  # Call the function to scrape the data

    # output block
    json_data = json.dumps(scraped_data, indent=4)
    print(json_data)

    if use_mqtt:
        client.publish(pub_topic, json_data)

    # loop iteration timer
    time.sleep(get_interval)
