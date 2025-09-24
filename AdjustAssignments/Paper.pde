class Paper {
  AC current1AC;
  AC current2AC;
  ArrayList<AC> wanters;
  ArrayList<AC> willingers;
  ArrayList<AC> reluctanters;
  ArrayList<AC> nobidders;
  String paperID;
  String paperTitle;
  float left, top, right, bottom;
  float left2, top2, right2, bottom2;

  public Paper(String id, String title) {
    
    paperID = id.substring(2, id.length());
    paperTitle = title;
    wanters = new ArrayList<AC>();
    willingers = new ArrayList<AC>();
    reluctanters = new ArrayList<AC>();
    nobidders = new ArrayList<AC>();
  }

  void setPrimaryCoords(float cx, float cy, float rectWidth, float rectHeight) {
    left = cx - rectWidth/2;
    right = cx + rectWidth/2;
    top = cy - rectHeight/2;
    bottom = cy + rectHeight/2;
  }

  void setSecondaryCoords(float cx, float cy, float rectWidth, float rectHeight) {
    left2 = cx - rectWidth/2;
    right2 = cx + rectWidth/2;
    top2 = cy - rectHeight/2;
    bottom2 = cy + rectHeight/2;
  }

  boolean contains(float x, float y) {
    return (x >= left && x <= right && y >= top && y <= bottom) || 
      (x >= left2 && x <= right2 && y >= top2 && y <= bottom2);
  }
}
