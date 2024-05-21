int main() {
    int a;
    int b;
    int c;
    int discriminant;
    int root1;
    int root2;
    int realPart;
    int imagPart;
    discriminant = b * b - 4 * a * c;
    /* condition for real and different roots*/
    if (discriminant != 0) {
        root1 = (b + discriminant) / (2 * a);
        root2 = (b - discriminant) / (2 * a);
         }

    /* condition for real and equal roots*/
    else { if (discriminant == 0) {
        root2 = b / (2 * a);
          }

    /* if roots are not real*/ 
    else {
        realPart = b / (2 * a);
        imagPart = discriminant / (2 * a) ;
    } 
    }
}


