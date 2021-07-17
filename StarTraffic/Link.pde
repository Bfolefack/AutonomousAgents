class Link {
  Star pointA;
  Star pointB;
  
  Link(Star A, Star B){
    pointA = A;
    pointB = B;
    //println(A, B);
    pointA.links.add(this);
    pointB.links.add(this);
  }
  
  Star getOtherStar(Star s){
    if(s == pointA)
      return pointB;
    else if(s == pointB)
      return pointA;
    else
      return null;
  }
}
