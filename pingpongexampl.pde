import processing.sound.*;
import gifAnimation.*;
//posicion
float cir_x = 300;
float cir_y = 20;

// desplazamento mov = pelota, ace = jugador
float mov_x = 3;
float mov_y = -2;
float ace = 5.0;

//para mov_y
float ang = 0;

//puntuaciones
int marc1 = 0;
int marc2 = 0;

//posiciones jugador 1 y 2
float pos1 = 10;
float pos2 = 10;

//verificacion controles
boolean[] tecla = new boolean[4];
//timeout (cuando marca punto)
float tiempo = 30;

boolean stop = false;

//sonido
SoundFile playera;
SoundFile playerb;
SoundFile start;
String sound;
//grabar
GifMaker ficherogif;
//menu
int menu = 0;


void setup() {
  size(800, 400);
  pos1 = height/2-25;
  pos2 = height/2-25;
  cir_x = width/2;
  cir_y = random(height);
  
  
  
  playera = new SoundFile(this,"sounda.wav");
  playerb = new SoundFile(this,"soundb.wav");
  start = new SoundFile(this,"start.wav");
  
  //gif
  //ficherogif = new GifMaker(this, "animacion.gif");
  //ficherogif.setRepeat(0);        // anima sin fin
}
void draw() {
  background(0);
  stroke(255,255,255);
  fill(255);
  
  
  
  if(menu != 0){
    //movimiento
    cir_x = cir_x + mov_x;
    cir_y = cir_y + mov_y + ang;
  
    menu = gui(menu);
    rebote();
    collision();
  }
  
  
  
  //comprobación de movimiento
  if (keyPressed){
    if (tecla[0]){
      if(pos1 >= 0){
        pos1 -= ace;
      }
    }
    if (tecla[1]){
      if(pos1 <= height-50){
        pos1 += ace;
      }
    }
    if (tecla[2]){
      if(pos2 >= 0){
        pos2 -= ace;
      }
    }
    if (tecla[3]){
      if(pos2 <= height-50){
        pos2 += ace;
      }
    }
    if (key == 'h' || key == 'H'){
      menu = 0;
    }
    if (key == ' '){
      if(menu == 0){
        sound = "start";
        thread ("playSound");
      }
      menu = 1;
    }
    if(key == 'r' || key == 'R'){
      if(marc1 >= 3 || marc2 >= 3){
         marc1 = 0;
        marc2 = 0;
        mov_x = 3;
        mov_y = -2;
        cir_y = random(height);
      }
    }
  }
  }
  
  //pelota en el medio, minipausa
  if (stop == true){
    if (tiempo <= 0){
      stop = false;
      if(mov_y >= 0){  
        mov_x = 3;
        mov_y = 2;
      } else{
        mov_x = -3;
        mov_y = -2;
      }
      tiempo = 30;
    }
    tiempo -=1;
  }
  
  
  //fin del juego, gana alguien
  if(marc1 >= 3 || marc2 >= 3){
    victoria();
  }
  
  if (menu == 0){
    menu = gui(menu);
  }
  
  //ficherogif.setDelay(1000/60);
  //ficherogif.addFrame();
}

//funcion para guardar las teclas pulsadas simultaneas
void movimiento(int k, boolean b) {
  switch (k) {
  case 'w':
    tecla[0] = b;
    break;
  case 'W':
    tecla[0] = b;
    break;
  case 's':
    tecla[1] = b;
    break;
  case 'S':
    tecla[1] = b;
    break;
  case 'u':
    tecla[2] = b;
    break;
  case 'U':
    tecla[2] = b;
    break;
  case 'j':
    tecla[3] = b;
    break;
  case 'J':
    tecla[3] = b;
    break;
  }
}

void keyPressed() {
  movimiento(key, true);
}

void keyReleased() {
  movimiento(key, false);
}

void playSound(){
  switch (sound) {
    case "playera":
      playera.play();
      break;
    case "playerb":
      playerb.play();
      break;
    case "start":
      start.play();
      break;
  }
}

void mousePressed() {
  //ficherogif.finish();          // Finaliza captura y salva
}

void collision(){
  //si la bola toca el jugador, rebota 
  if((cir_x >= 0 && cir_x-mov_x <= 20) && (cir_y >= pos1 && cir_y <= pos1+50)){
    
    if(mov_x*1.1 <= 10){
      mov_x = -mov_x*1.1; //mov_x no puede superar 10
    } else{
      mov_x = -mov_x;
    }
    ang = -2+4*((cir_y-pos1)/50);
    if(mov_y >= 0 && cir_y-pos1 <= 25){
      mov_y *= -1;
    }
    if(mov_y <= 0 && cir_y-pos1 >= 25){
      mov_y *= -1;
    }
    cir_x = 20.1; //evitar sobrecolision
    sound = "playera";
    thread ("playSound");
  }
  //jugador 2
  if((cir_x >= width-30 && cir_x <= width) && (cir_y >= pos2 && cir_y <= pos2+50)){
   if(mov_x*1.1 <= 10){
      mov_x = -mov_x*1.1; //mov_x no puede superar 10
    } else{
      mov_x = -mov_x;
    }
    ang = -2+4*((cir_y-pos2)/50);
    if(mov_y >= 0 && cir_y-pos2 <= 25){
      mov_y *= -1;
    }
    if(mov_y <= 0 && cir_y-pos2 >= 25){
      mov_y *= -1;
    }
    cir_x = width-30.1; //evitar sobrecolision
    sound = "playerb";
    thread ("playSound");
  }
}

int gui(int menu){
  if (menu != 0){
    for(int i = 0; i < width; i=i+20){
      line(width/2,0+i,width/2,12+i);
    }
    
    //jugador derecho
    rect(width-20,pos2,10,50);
  
    //jugador izquierdo
    rect(10,pos1,10,50);
    rect(cir_x, cir_y, 10,10);
    fill(255);
  
    //marcador 1
    marcador(marc1,40,25);
    
    //marcador 2
    marcador(marc2,width-70,25);
    
    
    
    //angulo, movimiento (debug)
    //textFont(createFont("Verdana",10));
    //text(ang,cir_x,cir_y+10);
    //text(mov_x,cir_x,cir_y+20); 
    
  } else {
    //texto
    textAlign(CENTER,CENTER);
    textFont(createFont("Verdana",40));
    text("Pong",width/2,20);
    text("Jugador1",150,height/2-140);
    textFont(createFont("Georgia",20));
    text("W - Arriba",150,height/2-100);
    text("S - Abajo",150,height/2-60);
    
    textFont(createFont("Times New Roman",40));
    text("Jugador2",width-150,height/2-140);
    textFont(createFont("Georgia",20));
    text("U - Arriba",width-150,height/2-100);
    text("J - Abajo",width-150,height/2-60);
    
    text("Pulsa H para ver los controles",width/2,height-80);
    text("Pulsa espacio para empezar",width/2,height-40);
  }
  return menu;
      
}

void rebote(){
  //llega a la izquierda o derecha, puntuacion para el de la izquierda
  if(cir_x > width || cir_x < 0) {
    ang = 0;
    if(cir_x > width){ 
      marc1++;
    }else{
      marc2++;
    }
    
    cir_x = (width/2)-5;
    cir_y = random(height);
    stop = true;
    mov_x = 0;
    
    //println("derecha");
    sound = "start";
    thread ("playSound");
  }
  //hacia abajo
  if(cir_y >= height-10) {
    cir_y = height-10;
    mov_y = -mov_y;
    ang = -ang;
    //println("abajo");
  }
  //hacia arriba
  if(cir_y < 0) {
    cir_y = 0;
    mov_y = -mov_y;
    ang = -ang;
    //println("arriba");
  }
}

void victoria(){
  mov_x = 0;
  mov_y = 0;
  cir_y = -100;
    
  fill(0);
  rect(width/2-100,height/2-100,200,100);
  fill(255);
  textFont(createFont("Georgia",15));
  textAlign(CENTER, CENTER);
  text("El ganador es:", width/2,height/2-50);
  if (marc1 > marc2){
    textFont(createFont("Georgia",20));
    text("Jugador1", width/2,height/2-40);
  } else {
    textFont(createFont("Georgia",20));
    text("Jugador2", width/2,height/2-40);
  }
  
  textFont(createFont("Georgia",30));
  textAlign(CENTER, CENTER);
  text("Pulsa R para reiniciar", width/2,height-30);
  
  
}

void marcador(int n,int x, int y){
  switch(n){
    case 0:
      rect(x,y,10,50);
      rect(x+10,y,20,10);
      rect(x+10,y+40,20,10);
      rect(x+20,y+10,10,40);
    break;
    case 1:
      rect(x+10,y,10,50);
    break;
    case 2:
      rect(x,y,30,50);
      fill(0);
      stroke(0);
      rect(x,y+10,20,10);
      rect(x+10,y+30,20,10);
      fill(255);
      stroke(255);
    break;
    case 3:
      rect(x,y,30,50);
      fill(0);
      stroke(0);
      rect(x,y+10,20,10);
      rect(x,y+30,20,10);
      fill(255);
      stroke(255);
    break;
  }
}
