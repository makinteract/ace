class AC {
  ArrayList<Paper> want;
  ArrayList<Paper> willing;
  ArrayList<Paper> reluctant;
  ArrayList<Paper> conflict;
  ArrayList<Paper> noBid;
  ArrayList<Paper> primary;
  ArrayList<Paper> secondary;
  ArrayList<Paper> originalPrimary;
  ArrayList<Paper> originalSecondary;
  String name;
  boolean notOnSC;

  public AC(String newName) {
    notOnSC = false;
    name  = newName;
    want = new ArrayList<Paper>();
    willing = new ArrayList<Paper>();
    reluctant = new ArrayList<Paper>();
    conflict = new ArrayList<Paper>();
    noBid = new ArrayList<Paper>();
    primary = new ArrayList<Paper>();
    secondary = new ArrayList<Paper>();
    originalPrimary = new ArrayList<Paper>();
    originalSecondary = new ArrayList<Paper>();
  }

  public void drawPerson(float y) {
    fill(200);
    float cx = divLine/2;
    float cy = y + yStep/2;
    String matchString = "";

    // want = green
    // willing = cyan
    // reluctant = yellow
    // no bid = white
    // conflict = red
    
    if (selectedPaper != null) {
      if (want.contains(selectedPaper)) {
        fill(0, 255, 0);
      }
      if (willing.contains(selectedPaper)) {
        fill(0, 255, 255);
      }
      if (reluctant.contains(selectedPaper)) {
        fill(255, 255, 0);
      }
      if (conflict.contains(selectedPaper)) {
        fill(255, 0, 0);
      }
      if (noBid.contains(selectedPaper)) {
        fill(255);
      }
      if (matches.containsKey(name + "|" + selectedPaper.paperID)) {
        matchString = matches.get(name + "|" + selectedPaper.paperID);
      }
    }

    if (this == selectedPerson) {
      strokeWeight(7);
    }
    rect(cx, cy, divLine-20, yStep);
    rect(width-cx, cy, divLine-20, yStep);
    fill(0);
    text(name + " " + matchString + " " + (primary.size() + secondary.size()), cx, cy);
    text(name + " " + matchString, width-cx, cy);
    //text("Anonymous AC" + " " + matchString, cx, cy);
    strokeWeight(1);
  }

  public void drawAssignments(float y) {
    float cx = divLine + xStep/2;
    float cy = y + yStep/2;
    strokeWeight(1);
    for (Paper p : primary) {
      if (p == selectedPaper) {
        strokeWeight(7); 
        stroke(255, 0, 255);
      }
      fill(200);
      if (want.contains(p)) {
        fill(0, 255, 0);
      }
      if (willing.contains(p)) {
        fill(0, 255, 255);
      }
      if (reluctant.contains(p)) {
        fill(255, 255, 0);
      }
      if (conflict.contains(p)) {
        fill(255, 0, 0);
      }
      if (noBid.contains(p)) {
        fill(255);
      }
      if (selectedPerson != null) {
        fill(150);
        strokeWeight(7);
        if (selectedPerson.want.contains(p)) {
          stroke(0, 255, 0);
        }
        if (selectedPerson.willing.contains(p)) {
          stroke(0, 255, 255);
        }
        if (selectedPerson.reluctant.contains(p)) {
          stroke(255, 255, 0);
        }
        if (selectedPerson.conflict.contains(p)) {
          stroke(255, 0, 0);
        }
        if (selectedPerson.noBid.contains(p)) {
          stroke(255);
        }
      }
      rect(cx, cy, xStep-10, yStep-10);
      strokeWeight(1);
      stroke(0);
      p.setPrimaryCoords(cx, cy, xStep-10, yStep-10);
      fill(0);
      text(p.paperID, cx, cy);
      //text("0000", cx, cy);
      cx += xStep;
    }
    //cx = divLine + (xStep * 8.5);
    cx = secondaryLine + xStep / 2;
    for (Paper p : secondary) {
      if (p == selectedPaper) {
        strokeWeight(7); 
        stroke(255, 0, 255);
      }
      fill(200);
      if (want.contains(p)) {
        fill(0, 255, 0);
      }
      if (willing.contains(p)) {
        fill(0, 255, 255);
      }
      if (reluctant.contains(p)) {
        fill(255, 255, 0);
      }
      if (conflict.contains(p)) {
        fill(255, 0, 0);
      }
      if (noBid.contains(p)) {
        fill(255);
      }
      if (selectedPerson != null) {
        fill(150);
        strokeWeight(7);
        if (selectedPerson.want.contains(p)) {
          stroke(0, 255, 0);
        }
        if (selectedPerson.willing.contains(p)) {
          stroke(0, 255, 255);
        }
        if (selectedPerson.reluctant.contains(p)) {
          stroke(255, 255, 0);
        }
        if (selectedPerson.conflict.contains(p)) {
          stroke(255, 0, 0);
        }
        if (selectedPerson.noBid.contains(p)) {
          stroke(255);
        }
      }
      rect(cx, cy, xStep-10, yStep-10);
      strokeWeight(1);
      stroke(0);
      p.setSecondaryCoords(cx, cy, xStep-10, yStep-10);
      fill(0);
      text(p.paperID, cx, cy);
      //text("0000", cx, cy);
      cx += xStep;
    }
    strokeWeight(1);
    stroke(0);
  }
}
