/***************************************************
 *  GPS Conversion
 *  Created by David Jan Mercado 2016
 *  www.davidjanmercado.com
 ***************************************************/

STable gpsdata;
int rowCount;

// Save the decimal values to a new table
Table newGPSdata;

// GPS in decimal
float dLat;
float dLong;

float MIN = 60f;
float SEC = 3600f;

float degrees;
float minutes;
float seconds;

void setup() {
  size(50, 50);
  
  gpsdata = new STable("photostestdata.csv");
  rowCount = gpsdata.getRowCount();
  
  newGPSdata = new Table();
  newGPSdata.addColumn("FileName");
  newGPSdata.addColumn("GPSLatitude");
  newGPSdata.addColumn("GPSLongitude");
  newGPSdata.addColumn("CreateDate");
  
  convertGPS();
  
  saveTable(newGPSdata, "data/photosGPStestdata.csv");
}

void convertGPS() {
  // Get data
  for (int row = 1; row < rowCount; row++) {
    String filename = gpsdata.getString(row, 1);
    String latitude = gpsdata.getString(row, 2);
    String longitude = gpsdata.getString(row, 3);
    String createdate = gpsdata.getString(row, 4);
    
    // Split deg min and sec (separated by ')
    String[] latList = split(latitude, "'");
    String[] longList = split(longitude, "'");
    
    // Latitude
    dLat = getGPSData(latList, row);
    
    // Longitude
    dLong = getGPSData(longList, row);
    
    // Add data to each row
    TableRow newRow = newGPSdata.addRow();
    newRow.setString("FileName", filename);
    newRow.setFloat("GPSLatitude", dLat);
    newRow.setFloat("GPSLongitude", dLong);
    newRow.setString("CreateDate", createdate);
  }
}
   
float getGPSData(String[] list, int row) {
     // Get degrees then trim to remove spaces
     // Format: 49 deg 6' 33.02" OR 0 deg 8' 2.73"
    degrees = Float.parseFloat(trim(list[0].substring(1, 3)));
    
    // Get minutes
    if (degrees < 10) {
      minutes = Float.parseFloat(trim(list[0].substring(6)));
    } else {
      minutes = Float.parseFloat(trim(list[0].substring(7)));
    }
    
    // Get seconds
    if (list[1].charAt(5) == '"') {  
      seconds = Float.parseFloat(trim(list[1].substring(1, 5)));
    } else {
      seconds = Float.parseFloat(trim(list[1].substring(1, 6)));
    }
    
    float decimal = degrees + (minutes/60.0) + (seconds/3600.0);

    return decimal;
}
