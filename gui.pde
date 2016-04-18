class Gui{

                              Listascroll lista;
                              Bar_simple barra;
                              Buttonplay boton;
                              Buttonsimple loadmp3, loadm3u, clear, save;
                              PVector Posiciongui;
                              PVector posicionbarra;
                              PVector listaposicion;
                              PImage despliega,pliega;
                              PShape logo;
                              int Alto, Ancho;
                              float donde;
                              Gui(PVector posiciongui, int alto, int ancho){ 
                                          
                                        Posiciongui=posiciongui;
                                        Alto=alto;
                                        Ancho=ancho;
                                        boton=new Buttonplay((Ancho/2),25,20,20);
                                        
                                        posicionbarra=new PVector(5,40);
                                        barra=new Bar_simple(posicionbarra,Ancho-10,10);
                                        listaposicion=new PVector(5,60);
                                        lista=new Listascroll(listaposicion);
                                        
                                        lista.ancho_items=Ancho-15;
                                        lista.ancho_barra=10;
                                        lista.alto=175;
                                        lista.itemsvisibles=10;
                                        loadmp3=new Buttonsimple(10,250,25,50,"loadmp3.svg");
                                         loadm3u=new Buttonsimple(70,250,25,50,"loadm3u.svg");  
                                        clear=new Buttonsimple(130,250,25,50,"clear.svg");
                                        save=new Buttonsimple(190,250,25,50,"save.svg");
                                        logo=loadShape("thelab.svg");
                                        despliega=loadImage("desplegar.png");
                                        pliega=loadImage("replegar.png");                                        
                                        donde=0;
                              
                              
                              
                              }// fin constructor

                              void display(){
                                colorMode(RGB);
                              pushMatrix();
                              translate(Posiciongui.x,Posiciongui.y);
                              stroke (255,255,255,60);
                              line(0, 20, 0, height);
                              noStroke();
                              rectMode(CORNER);
                              fill(149,149,149,100);
                              rect(220,0, 20,15,5,5,0,0);
                              fill(255,255,255,20);
                               rect(0,15, Ancho, height);
                              //image(logo,0,500);
                                      shape(logo,0,650,240,90);
                                      boton.display();
                                      barra.display(donde);
                                      lista.display();
                                      loadmp3.display();
                                      loadm3u.display();
                                      clear.display();
                                      save.display();
                               stroke (255,255,255,60);
                               line(Ancho, 20, Ancho, height);
                               noStroke();
                               tint(255,125);
                                if (esta_arriba){image(pliega,222,0,15,15);}else{image(despliega,222,0,15,15);}
                              popMatrix();
                              if (estamosmoviendo && cancionatrapada>-1){fill(0,0,255);
                                                    textAlign(LEFT,BOTTOM);
                                                    String cadena=lista.Item.get(cancionatrapada);
                                                    if (cadena.length()>30){cadena=cadena.substring(0,31)+"...";}
                                                    text(cadena,mouseX,mouseY);}
                              }// fin display

                              void detectdeslizer(){
                                PVector vectorraton;
                                vectorraton=new PVector(mouseX, mouseY);
                                vectorraton.sub(gui.Posiciongui);
                                
                                if (vectorraton.x>220 && vectorraton.x<240){
                                if (vectorraton.y>0 && vectorraton.y<20){esta_arriba= !esta_arriba;}}
                                     }



}