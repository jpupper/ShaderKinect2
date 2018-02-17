/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  //println("MENSAJE :"+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());

  int index =0;
  
  if(theOscMessage.addrPattern().length() == 3){
    index = parseInt(theOscMessage.addrPattern().substring(2,3));
  }
  else {
    index = parseInt(theOscMessage.addrPattern().substring(2,4));
  }
  
  
  println("index :", index);
  
  shi[index] = theOscMessage.get(0).floatValue(); 
  println("SHI :" + index + " = " + shi[index]);
  
  /*
  if (theOscMessage.addrPattern().equals("/r")) {
    shi[0] = theOscMessage.get(0).floatValue();
    println("R :" +shi[0]  );
  }

  if (theOscMessage.addrPattern().equals("/g")) {
    shi[1]  = theOscMessage.get(0).floatValue();
    println("G :" +shi[1] );
  }
  if (theOscMessage.addrPattern().equals("/b")) {
    shi[2]  = theOscMessage.get(0).floatValue();
    println("B :" +shi[2]  );
  }*/
}