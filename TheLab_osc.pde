//Variables de minim
                import ddf.minim.spi.*;
                import ddf.minim.signals.*;
                import ddf.minim.*;
                import ddf.minim.analysis.*;
                import ddf.minim.ugens.*;
                import ddf.minim.effects.*;
                import oscP5.*;
                import netP5.*;

                Minim minim;
                AudioPlayer song;
                float signo=0;
                float Factor=50;
                float flujo=0;
                float[] fft_value;
                int bufferSize=512;
                FFT fft;

//Variables de GUI
                int vis_height, vis_width;
                public ArrayList<String> listacanciones, listatitulos;
                public boolean breveclick=false, estamosmoviendo=false, esta_arriba=true;
                public int superpuntero=-1, cancionatrapada=-1;
                String[] lines, canciones;
                Gui gui;
                //int target_arriba, target_abajo;
                PVector posicion_gui;
                PImage sombra;
//Variables OSC
                OscP5 oscP5_1, oscP5_2;
                NetAddress dest, dest2;
     
                


void setup() {
                                  size(260, 500, P2D);
                                  smooth(8);
                                  frameRate(60);
                                  
                                  //setup gui
                                  posicion_gui=new PVector (0, 0);
                                  gui=new Gui(posicion_gui, 350, 250);
                                  listacanciones=new  ArrayList<String>();
                                  listatitulos=new  ArrayList<String>();
                                  //target_arriba=0;
                                  //target_abajo=height-52;
                                  sombra = loadImage("sombra.png");
                                  //setup minim
                                  minim = new Minim(this);
                                  song = minim.loadFile("dummy_01.mp3",bufferSize);
                                  fft = new FFT( song.bufferSize(), song.sampleRate() );
                                  //
                                  //setup OSC
                                  oscP5_1 = new OscP5(this,12000); //escuchando en 12000
                                  oscP5_2= new OscP5(this,12001); //escuchando en 12001
                                   //dest = new NetAddress("127.0.0.1",6448); //enviando a 6448
                                   
                                  // dest2 = new NetAddress("127.0.0.1",6449); 
                                    dest = new NetAddress("255.255.255.255",6448);
                                     dest2 = new NetAddress("255.255.255.255",6449);
                                  //dest = new NetAddress("192.168.0.104",6448); //enviando a 6448
                                  
                                  fft_value=new float[song.bufferSize ()] ;
                                  
}//fin setup




void draw() {
  background(40,40,206);
  //background(206,40,40);
  image(sombra, 0, 0,width,height);
  //lee valores de musica 
                              fft.forward( song.mix );

                              for (int i = 0; i < song.bufferSize () - 1; i++)
                              {
                                signo=signo+song.mix.get(i);
                                fft_value[i]=fft.getBand(i);
                              }
                              if (signo>0) {
                                signo=signo/-signo;
                              } else {
                                signo=1;
                              }
                              flujo=song.mix.level()*(Factor*signo);
                              //Sending
                              sendOsc_int(flujo,dest);
                              sendOsc_fft(fft_value,dest2);
                              
// Aqui esta el visualizador

//fin visualizador








//Visualización GUI
                        if (song.isPlaying()) {gui.donde=(float(song.position())/float(song.length()));}
                        if ((float(song.position())/float(song.length()))>.98 && superpuntero<listacanciones.size()) {
                          inicianuevacancion();
                              }

                         // if (esta_arriba && target_arriba!=gui.Posiciongui.y) {
                          //  gui.Posiciongui.y=target_arriba;
                         // }
                         // if (!esta_arriba && target_abajo!=gui.Posiciongui.y) {
                          //  gui.Posiciongui.y=target_abajo;
                          //}
                         gui.display();
}//fin draw

void sendOsc_int(float valor,NetAddress dest) {

 OscMessage msg = new OscMessage("/intensidad");
 msg.add((float)valor); 
 oscP5_1.send(msg, dest);
 
}
void sendOsc_fft(float[] fft_value, NetAddress dest) {

 OscMessage msg = new OscMessage("/fft_value");
 
    for (int i = 0; i <fft_value.length - 1; i++)
       {msg.add((float)fft_value[i]);} 
       
  oscP5_2.send(msg, dest);
 
}



void keyPressed() {

  //song.play();
  if (key=='l')
  {
    selectInput("Musica:", "fileSelected");
  }
} 



void fileSelected(File selection) { 
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    if (match (selection.getAbsolutePath(), ".mp3")!=null)
    { 
      listacanciones.add( selection.getAbsolutePath());    


      String[] cortes=splitTokens(selection.getAbsolutePath(), "\\");
      listatitulos.add(cortes[cortes.length-1]);

      gui.lista.additem(cortes[cortes.length-1]);
    }
  }
}

void inicianuevacancion() {

  superpuntero++;
  gui.lista.index_activo=superpuntero;
  gui.boton.isPlay=false;
  try { 
    song = minim.loadFile(listacanciones.get(superpuntero),bufferSize);
    song.play();
    gui.boton.isPlay=true;
  } 
  catch(Exception e) {
    println("again");
  }
}








void mousePressed() {
  breveclick=true;
  cancionatrapada=gui.lista.cazaitem();

  if (gui.barra.detect_clic()!=-1.0) {
    if (song.isPlaying()) {
      song.cue(int(gui.barra.detect_clic()*song.length()));
    }
  }
  if (gui.boton.detectclic()) {
    if (song.isPlaying()) {
      song.pause();
      gui.boton.isPlay=false;
    } else {
      if (listacanciones.size()>0)
      {
        if (superpuntero==-1) {
          inicianuevacancion();
        } else {
          song.play();
          gui.boton.isPlay=true;
        }
      } else {
        gui.boton.isPlay=false;
      }
    }
  }

  gui.detectdeslizer();

  if (gui.loadmp3.detect()) {
    selectInput("Musica:", "fileSelected");
  }
  if (gui.loadm3u.detect()) {
    selectInput("Lista de reproducción:", "leem3u");
  }
  if (gui.clear.detect()) {
                                                      if (song.isPlaying()) {
                                                        song.pause();
                                                        gui.boton.isPlay=false;
                                                        minim.stop();
                                                        flujo=0;
                                                      }
                                                       listacanciones.clear();
                                                       listatitulos.clear();
                                                       gui.lista.Item.clear();
                                                       
                                                      superpuntero=-1;
                                                      gui.lista.indice_lista=-1;
                                                      gui.lista.index_activo=-1;
                                                      gui.donde=0;
  
                                }
  
 if (gui.save.detect()) {selectOutput("Save selection list:", "savem3u");
                           } 
  
  
}


void mouseDragged() {
  if (gui.lista.detectscroll()) {
    breveclick=false;
    if (pmouseY<mouseY) {
      gui.lista.indice_lista++;
    } else {
      gui.lista.indice_lista--;
    }
  }

  if (gui.lista.detectenlista()) {
    breveclick=false;
    estamosmoviendo=true;
  }
}



void mouseReleased() {

  estamosmoviendo=false;

  if (gui.lista.detectenlista() && breveclick) {      
    gui.lista.activa();
    if (gui.lista.index_activo!=superpuntero) {
      try {
        minim.stop();
        song = minim.loadFile(listacanciones.get(gui.lista.index_activo),bufferSize);
        superpuntero=gui.lista.index_activo;
      } 
      catch(Exception e) {
        println("again");
      }
      song.play();
      gui.boton.isPlay=true;
      //println(listacanciones.get(gui.lista.index_activo));
    }
  }// Aquí activamos una nueva canción


  if (gui.lista.detectenlista() && !breveclick && cancionatrapada>-1 && gui.lista.dragging==true) {
                                                  String cancionmovida=listacanciones.get( cancionatrapada);
                                                  String cancionmovidatitulo=listatitulos.get( cancionatrapada);
                                                  int indiceinsercion=gui.lista.cazaitem();
                                                  
                                                      if (superpuntero>-1 && superpuntero==cancionatrapada) {
                                                                                                    superpuntero=indiceinsercion;
                                                                                                    if (indiceinsercion>cancionatrapada){superpuntero--;}
                                                                                                    //gui.lista.index_activo=superpuntero;
                                                                                                                                      } 
                                                     else {
                                                                                                    if (superpuntero>-1 && superpuntero>=indiceinsercion) {
                                                                                                      superpuntero=superpuntero+1;
                                                                                                     // gui.lista.index_activo=superpuntero;
                                                                                                    }
                                                                                                    if (superpuntero>-1 && superpuntero<=indiceinsercion) {
                                                                                                      superpuntero=superpuntero-1;
                                                                                                      //gui.lista.index_activo=superpuntero;
                                                                                                    }
                                                                                                    
                                                        }
                                                   gui.lista.index_activo=superpuntero;
                                                  
                                                  
                                                  
                                                  //if (indiceinsercion<cancionatrapada && indiceinsercion>-1) {
                                                    //cancionatrapada++;
                                                    //gui.lista.index_activo=superpuntero+1;
                                                  //}
                                                  
                                                  if (indiceinsercion<0) {
                                                    indiceinsercion=gui.lista.Item.size();
                                                    superpuntero=gui.lista.Item.size();
                                                  }
                                                  listacanciones.add(indiceinsercion, cancionmovida);
                                                  listatitulos.add( indiceinsercion, cancionmovidatitulo);
                                                  gui.lista.Item.add(indiceinsercion, cancionmovidatitulo);
                                              
                                                  listacanciones.remove(cancionatrapada);
                                                  listatitulos.remove(cancionatrapada);
                                                  gui.lista.Item.remove(cancionatrapada);




    //if (indiceinsercion<0){indiceinsercion=gui.lista.Item.size();superpuntero=gui.lista.Item.size();gui.lista.index_activo=superpuntero;}
  }
    gui.lista.scrolling=false;
  gui.lista.dragging=false;
}  