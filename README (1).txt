
# EMBEDDED SYSTEMS PROJECT FOR PULSE DETECTION

Our project's goal is to present a PCB-level prototype of a platform for wireless wrist pulse recording.

The hardware components used in this project are as follows:
1) ESP32 XIAO microcontroller
2) Sensors MAX30102
3) The Multiplexer PCA9548A
We make use of Processing software and Arduino. Here's a sneak peek at our finished hardware: "https://ibb.co/zhf7cQn" and the pulse waveforms that were produced: "https://ibb.co/NnY8bvG".

The "Wireless.ino" code on the Arduino IDE and the "processing_code.pde" code on the processing software must be written before we can begin. The code uses the laptop as a host and the microcontroller as a client to send data wirelessly. The following sums up the functions of the GUI code:

Graphical User Interface (GUI): The application uses the ControlP5 library to generate a GUI that has buttons, tables, as well as charts.

Serial communication sets up a server to receive data over TCP/IP via a network connection and parse it.

Data Visualization: Real-time data from three sensors (perhaps connected to Kapha, Vatta, and Pitta) is displayed using charts.

Data processing: After processing the sensor data that was received, the algorithm calculates the maximum and minimum values and updates the charts appropriately.

File Handling: When the corresponding button is pressed, the sensor data is saved to a CSV file and the user is able to input a name using a textfield.

Control Flags: To regulate the data gathering and saving procedures, the application has three flags: start_flag, stop_flag, and save_flag.

User Interaction: Using the GUI's given buttons, the user can begin, stop, and save data.

Here is a brief synopsis of the Arduino code:
For a device with three MAX30102 pulse oximeter sensors, this Arduino code was created. The gadget establishes a connection with a Wi-Fi network and uses the TCP protocol to communicate the IR (infrared) readings from each sensor to a designated server IP address and port. The infrared values from every sensor are formatted as a string and are separated by commas. The apparatus keeps doing this over and over.

