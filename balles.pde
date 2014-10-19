/*************

Adrien Bocquet - 2014

Calculs de collision issus de Wikipédia
http://fr.wikipedia.org/wiki/Choc_élastique

*************/

Balle[] balles ;

void setup()
{
  frameRate(60);

  size(640, 480);
  balles = new Balle[50] ;

  for (int i = 0; i < balles.length; i++)
  {
    balles[i] = new Balle() ;
  }
}

void draw() {

  background(255, 255, 255) ;

  for (int i = 0; i < balles.length; i++) { 
    balles[i].move();
    balles[i].border();

    for (int y = i+1; y < balles.length; y++) {
      balles[i].collision(balles[y]);
    }

    balles[i].draw();
  }
}

class Balle {

  float x, y, vx, vy, s; 
  float r, g, b; 

  Balle() {
    s = 25; 
    x = random(10, width - 10); 
    y = random(10, height - 10); 
    vx = random(2, 7) * (random(-1, 1) > 0 ? 1 : -1); 
    vy = random(2, 7) * (random(-1, 1) > 0 ? 1 : -1); 


    r = random(150, 255); 
    g = random(150, 255); 
    b = random(150, 255);
  }

  void collision(Balle other) {

    if (pow((this.x - other.x), 2) + pow((this.y - other.y), 2) <= pow((this.s + other.s)/2, 2) )
    {

      // Les boules sont positionnées au point de contact
      // (m.x,m.y) = centre de la boule m (repère de l'image)
      // (m.vx,m.vy) = vitesse de la boule m avant le choc (repère de l'image)

      // Calcul de la base orthonormée (n,g)
      // n est perpendiculaire au plan de collision, g est tangent
      float nx = (other.x - this.x)/s; 
      float ny = (other.y - this.y)/s; 
      float gx = -ny; 
      float gy = nx; 

      // Calcul des vitesses dans cette base
      float v1n = nx*this.vx + ny*this.vy; 
      float v1g = gx*this.vx + gy*this.vy; 
      float v2n = nx*other.vx + ny*other.vy; 
      float v2g = gx*other.vx + gy*other.vy; 

      // Permute les coordonnées n et conserve la vitesse tangentielle
      // Exécute la transformation inverse (base orthonormée => matrice transposée)
      this.vx = (nx*v2n +  gx*v1g) * 1.1; 
      this.vy = (ny*v2n +  gy*v1g) * 1.1; 
      other.vx = nx*v1n +  gx*v2g; 
      other.vy = ny*v1n +  gy*v2g;

      while (pow ( (this.x - other.x), 2) + pow((this.y - other.y), 2) <= pow((this.s + other.s)/2, 2))
      {
        this.x += this.vx ;
        this.y += this.vy ;
        other.x += other.vx ;
        other.y += other.vy ;

        this.border();
        other.border();
      }
    }
  }

  void border() {
    if (x - s/2 <= 0 || x + s/2>= width) {
      vx *= -1;
    }
    if (y - s/2 <= 0 || y + s/2>= height) {
      vy*=-1;
    }
  }

  void move() {
    x += vx; 
    y+= vy;
  }

  void draw() {
    noStroke(); 
    fill(r, g, b); 
    ellipse(x, y, s, s);
  }
}

