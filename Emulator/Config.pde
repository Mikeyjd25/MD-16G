public static void MakeConfig() {
  String props_file ="defaults.properties";
  String full_path = cur_path + props_file;
  File file = new File(full_path);

  boolean b = false;

  if(!file.exists()) {
    println("The file does not exsist creating file...");

    Properties prop = new Properties();
    OutputStream output = null;

    try {
      output = new FileOutputStream(full_path);

      // set the properties value
      prop.setProperty("Rom_Location", "../TestCode/Bootloader.rom");
      prop.setProperty("scaling", "2");

      // save properties
      prop.store(output, null);

    } catch (IOException io) {
      io.printStackTrace();
    } finally {
      if (output != null) {
        try {
          output.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
  }
}

public static String Rom_Location;
public static int scaling = 1;


public static void GetConfig(){
  String props_file ="defaults.properties";
  String full_path = cur_path + props_file;
  File file = new File(full_path);

  Properties prop = new Properties();
  InputStream input = null;

  try {

    input = new FileInputStream(full_path);

    // load a properties file
    prop.load(input);

    // get the property value and print it out
    Rom_Location = prop.getProperty("Rom_Location");

    try {
      scaling = Integer.parseInt(prop.getProperty("scaling"));
    } catch (NumberFormatException e) {
      e.printStackTrace();
    }


  } catch (IOException ex) {
    ex.printStackTrace();
  } finally {
    if (input != null) {
      try {
        input.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }


}