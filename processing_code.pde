import controlP5.*; //import ControlP5 library
import processing.serial.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.*;
import java.io.File ;
import java.io.FileWriter;
import java.io.BufferedWriter;
//import com.google.common.primitives.Floats;
int N  = 100; 
import processing.net.*;




int port = 12345;       
Server myServer;     

Chart myChart1;
Chart myChart2;
Chart myChart3;
ControlP5 cp5; //create ControlP5 object
PFont font;
int nl = 10; 
String received = null;
String [] readings;
int stop_flag = 0;
int start_flag = 0;
int save_flag = 0 ;
float values1[];
float values2[];
float values3[];
String name;
int flag = 0 ;
float max1 = 0 , min1 = 200000.0 , max2 = 0 , min2 = 200000.0 , min3 = 200000.0 , max3 = 0;
int ct = 0 ;
int chk = 0;
float r1 = 0 ,r2 = 0 ,r3 = 0 ;

void setup(){ 
  frameRate(60);
  size(1200, 750);    //window size, (width, height)
  values1 = new float[N];
  values2 = new float[N];
  values3 = new float[N];
  values1[0] = 200000;
  values2[0] = 200000;
  values3[0] = 200000;
  printArray(Serial.list());   //prints all available serial ports
  
  //port = new Serial(this, "COM13", 115200);
  myServer = new Server(this, port);
  //lets add buttons and charts to empty window
  
  cp5 = new ControlP5(this);
  font = createFont("calibri light bold", 20);    // custom fonts for buttons and title
  
  cp5.addButton("Name")     //"Start" is the name of button
    .setPosition(60, 70)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)  
  ;
  
  cp5.addTextfield("input")
     .setPosition(260,70)
     .setSize(400,70)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,255,255))
     ;
     
  cp5.addButton("Start")     //"Start" is the name of button
    .setPosition(60, 240)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)  
  ;   

  cp5.addButton("Stop")     //"Stop" is the name of button
    .setPosition(60, 340)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
  
  cp5.addButton("Save_On")     //"Save" is the name of button
    .setPosition(60, 440)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
  
  cp5.addButton("Save_Off")     //"Save" is the name of button
    .setPosition(60, 540)  //x and y coordinates of upper left corner of button
    .setSize(120, 70)      //(width, height)
    .setFont(font)
  ;
  
  myChart1= cp5.addChart("Kapha")
    .setPosition(260, 210)
    .setSize(900, 125)
    .setView(Chart.LINE)
    //.setRange(47000,51000)
    .setStrokeWeight(1.5)
    
    ;

  myChart1.addDataSet("incoming");
  myChart1.setData("incoming", new float[N]);
  
  myChart2 = cp5.addChart("vatta")
    .setPosition(260, 355)
    .setSize(900, 125)
    .setView(Chart.LINE)  
    //.setRange(37000,41000)
    ;

  myChart2.addDataSet("incoming");
  myChart2.setData("incoming", new float[N]);
  
  myChart3 = cp5.addChart("pitta")
    .setPosition(260, 500)
    .setSize(900, 125)
    .setView(Chart.LINE)
    //.setRange(29000,32000)
    ;

  myChart3.addDataSet("incoming");
  myChart3.setData("incoming", new float[N]);
  myChart1.setColors("incoming",#FFFFFF);
  myChart2.setColors("incoming",#FFFFFF);
  myChart3.setColors("incoming",#FFFFFF);
  //save_data = createWriter("sensordata.txt"+day()+"-"+month()+"-"+year()+":"+hour()+"."+minute());
}

void draw()
{  //same as loop in arduino
  Client thisClient = myServer.available();
  background(0, 0, 0); // background color of window (r, g, b) or (0 to 255)
  //int ct_graph = 0 ;
  //
  //received = port.readStringUntil(nl);
  
  // If the client is not null, and says something, display what it said
  if(myServer.active() == true) 
  {
      //println("hi");
  } 
  else 
  {
      println("Server is not active."); 
  }
  if (thisClient != null && (start_flag == 1) && (stop_flag == 0)) 
  {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) 
    {
       //println(whatClientSaid);
       readings = whatClientSaid.split(",",3);
       r1 = float(readings[0]);
       r2 = float(readings[1]);
       r3 = float(readings[2]);
       if(flag < N )
      {
          values1[flag] = r1 ;
          values2[flag] = r2 ;
          values3[flag] = r3 ;
            
          for (int i = 0; i < values1.length; i++) 
          {  
              //Compare elements of array with max  
             if(values1[i] > max1)  
                 max1 = values1[i];  
           }
          for (int i = 0; i < values2.length; i++) 
          {  
              //Compare elements of array with max  
             if(values2[i] > max2)  
                 max2 = values2[i];  
           }
          for (int i = 0; i < values3.length; i++) 
          {  
              //Compare elements of array with max  
             if(values3[i] > max3)  
                 max3 = values3[i];  
           }
           int s1, s2 ,s3 ;
           if( chk == 1 ) 
           {
             s1 = N-1 ; 
             s2 = N-1 ; 
             s3 = N-1 ; 
           }
           else
           {
             s1 = s2 = s3 = flag ;
           }
          for (int i = 0; i < s1; i++) 
          {    
             if(values1[i] < min1)  
                 min1 = values1[i];  
             //println("hi");
          }
          for (int i = 0; i < s2 ; i++) 
          {    
             if(values2[i] < min2)  
                 min2 = values2[i];  
          }      
          for (int i = 0; i < s3 ; i++) 
          {    
             if(values3[i] < min3)  
                 min3 = values3[i];  
          }
          flag ++;
          if(flag == N-1)
          {
            chk = 1 ;
            min1 = values1[N-5];
            min2 = values2[N-5];
            min3 = values3[N-5];
            max1 = values1[0];
            max2 = values2[0];
            max3 = values3[0];
            flag = 0 ;
          } 
      }
      myChart1.setRange(min1,max1);
      myChart2.setRange(min2,max2);
      myChart3.setRange(min3,max3);
      println(min1,max1,min2,max2,min3,max3);
      //myChart1.setResolution(8);
      //myChart2.setResolution(5);
      //myChart3.setResolution(12);
      myChart1.setStrokeWeight(2.0);
      myChart2.setStrokeWeight(2.0);
      myChart3.setStrokeWeight(2.0);
      //myChart2.updateViewMode(1);
      //saveStrings("sensordata.txt", readings);
      //save_data.println(readings[0]+","+readings[1]+","+readings[2]);
      //hour()+"."+"0"+minute()+"."+second()+"."+millis()+" : 
      if((r1 < 10000) && (r2 < 10000) && (r3 < 10000))
      {
        readings[0] = str(0) ;
        readings[1] = str(0) ; 
        readings[2] = str(0) ;
      }
      myChart1.push("incoming", float(readings[0]));
      myChart2.push("incoming", float(readings[1]));
      myChart3.push("incoming", float(readings[2]));
      if(save_flag == 1)
      {
        try {
            // Create a FileWriter in append mode (true parameter)
            String path = "D://5TH SEM//EMBEDDED//File_handling//" + name + ".csv" ;
            FileWriter fileWriter = new FileWriter(path, true);
    
            // Append the data to the file  
            fileWriter.write(readings[0] + "," + readings[1] + "," + readings[2]);
            fileWriter.write("\n"); // Add a newline for separation (optional)
    
            // Close the FileWriter to release system resources
            fileWriter.close();
    
            System.out.println("Data appended to the file successfully.");
        } 
        catch (IOException e) 
        {
            System.err.println("An error occurred: " + e.getMessage());
        }
      } 
    } 
  } 
}

//lets add some functions to our buttons
//so when you press any button, it sends particular string over serial port

void Start(){
  start_flag = 1;
  stop_flag = 0;
}

void Stop(){
    stop_flag = 1;
    start_flag = 0;
    
    //exit();
}

void Save_On()
{
  save_flag = 1 ;
}

void Save_Off(){
  save_flag = 0 ;
}

public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
  name = theText;
}
