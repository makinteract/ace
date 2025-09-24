import java.io.*;

ArrayList<AC> people;
ArrayList<Paper> papers;
float yStep, xStep;
float y;
Paper selectedPaper;
int selectedRow;
int selectedSide;
boolean dragging;
int fromIndex;
int fromSide;
HashMap<String, String> matches;
float divLine;
float secondaryLine;
AC selectedPerson;
int maxLoad;
int primaryCount = 0;
int secondaryCount = 0;

PrintStream o, console;

void printRow(TableRow row) {
  for (int i = 0; i < row.getColumnCount(); i++) {
      if (i > 0) print(", "); // separator
      print(row.getString(i));
    }
    println(); // end of row
}

void setup() {
  console = System.out;
   try {
    o = new PrintStream(sketchPath("") + new File("debug.log")); 
  }
  catch(Exception e) {
    System.err.println("Unable to create file output stream");
  }
  
  // Set to System.setOut(o) instead of System.setOut(console) 
  // to write to debug.log file;
  System.setOut(console);
  
  //fullScreen();
  //size(2500, 1300);
  size(1920, 1080);
  people = new ArrayList<AC>();
  papers = new ArrayList<Paper>();
  matches = new HashMap<String, String>();

  //String[] lines = loadStrings("assignments.csv");
  
  Table table;
  table = loadTable("PCS-bids.csv", "csv");
  println(table.getRowCount() + " total rows in the table.");
  
  // Make ACs
  String[] parts;
  String name;
  int i;
  boolean starred;
  AC person;
  
  // The format of the initial rows are:
  // ID, Title, Person 1, Person 1, Person 1, Person 2, Person 2, Person 2
  //   ,      , bid     , stat    , match   , bid,    , stat    , match
  //
  TableRow peopleRow = table.getRow(2);
  for (i = 2; i < peopleRow.getColumnCount(); i = i + 3) {
   
   // Example field:
   // Person 1\n
   // 6 P, 7 S, 0 V
   parts = peopleRow.getString(i).split("\n");
   name = parts[0];
   
   starred = false;
   if (name.indexOf("*") != -1) {
        starred = true;
        println("Starred: " + name);
   }
   
   person = new AC(name);
   person.notOnSC = starred;
   people.add(person);
   println("Added: " + person.name + "," + person.notOnSC);
  }
  
  // Read paper lines (which start at row position 5)
  for (int r = 5; r < table.getRowCount(); r++) {
    TableRow row = table.getRow(r);
    setDetails(row);
  }

  println("There are " + papers.size() + " papers ************************************************");
  println("There are " + primaryCount + " papers with 1AC ************************************************");
  println("There are " + secondaryCount + " papers with 2AC ************************************************");

  // remove ACs not on SC
  ArrayList<AC> removed = new ArrayList<AC>();
  for (int k = 0; k < people.size(); k++) {
    //println(k + " Checking: " + people.get(k).name + "," + people.get(k).notOnSC);
    if (people.get(k).notOnSC) {
      //println(people.get(k).name + " is not on SC, removing");
      removed.add(people.get(k));
      //AC removed = people.remove(k);
      //println("Removed: " + removed.name + "," +removed.notOnSC);
    }
  }
  people.removeAll(removed);

  for (AC ac : people) {
    println("AC: " + ac.name);
  }

  printBidSummary();

  // read assignments file
  String[] assignmentLines = loadStrings("assignments.csv");
  for (String line : assignmentLines) {
    updateAssignments(line);
  }

  divLine = width / 10;
  secondaryLine = divLine + (width - divLine * 2) / 2;
  maxLoad = 10;
  println(people);
  yStep = (height-75) / people.size();
  xStep = (width - divLine * 2) / (maxLoad * 2);
  textSize(14);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  dragging = false;

  println("-----------------------------------------------------");
}

void draw() {
  background(100);
  //if (selectedPaper != null) {
  y = 0;

  fill(170);
  noStroke();
  rectMode(CORNER);
  if (selectedSide == 1) {
    //rect(divLine+xStep*(maxLoad/2), selectedRow*yStep+yStep/2, xStep*maxLoad, yStep);
    rect(divLine+5, selectedRow*yStep, xStep*maxLoad, yStep);
  } else {
    //rect(divLine+xStep*maxLoad+xStep*(maxLoad/2), selectedRow*yStep+yStep/2, xStep*maxLoad, yStep);
    rect(secondaryLine+5, selectedRow*yStep, xStep*maxLoad, yStep);
  }
  rect(0, selectedRow*yStep, width, yStep);
  stroke(0);
  rectMode(CENTER);
  //}

  for (AC person : people) {
    person.drawPerson(y);
    person.drawAssignments(y);
    y += yStep;
  }
  // status line
  fill(255);
  rect(width/2, height-(50/2), width, 50);
  if (selectedPaper != null) {
    fill(0);
    text(selectedPaper.paperTitle, width/2, height-(75/2));
    //text("Anonymous Paper Title", width/2, height-(75/2));
  }
  if (selectedPaper != null && dragging) {
    noFill();
    strokeWeight(10);
    rect(mouseX, mouseY, 100, yStep-10);
    fill(0);
    text(selectedPaper.paperID, mouseX, mouseY);
  }

  stroke(255);
  line(divLine, 0, divLine, height);
  line(secondaryLine, 0, secondaryLine, height);
  line(divLine + xStep * 6, 0, divLine + xStep * 6, height);
  line(secondaryLine + xStep * 6, 0, secondaryLine + xStep * 6, height);
}

void mouseDragged() {
  if (selectedPaper != null) {
    if (mouseY < height - 75) {
      selectedRow = int(mouseY / yStep);
      selectedRow = min(selectedRow, people.size()-1);
    }
    //selectedRow = int(mouseY / yStep);
    if (mouseX < secondaryLine) {
      selectedSide = 1;
    } else {
      selectedSide = 2;
    }
  }
}

void mouseMoved() {
  selectedPerson = null;
  if (mouseX < divLine || mouseX > (width-divLine)) {
    if (mouseY < height - 75) {
      selectedRow = int(mouseY / yStep);
      selectedRow = min(selectedRow, people.size()-1);
      selectedPerson = people.get(selectedRow);
    }
  }

  selectedPaper = null;
  for (Paper p : papers) {
    //println(mouseX, mouseY, p.left, p.top, p.right, p.bottom);
    if (p.contains(mouseX, mouseY)) {
      selectedPaper = p;
      break;
    }
  }
  //if (selectedPaper != null) {
  if (mouseY < height - 75) {
    selectedRow = int(mouseY / yStep);
    selectedRow = min(selectedRow, people.size()-1);
  }
  //selectedRow = int(mouseY / yStep);
  if (mouseX < secondaryLine) {
    selectedSide = 1;
  } else {
    selectedSide = 2;
  }
  //}
  //if (selectedPaper != null) {
  //  println("Selected " + selectedPaper.paperID);
  //} else {
  //  println("Nothing selected");
  //  Paper p = papers.get(0);
  //  println(p.paperID,mouseX, mouseY, p.left, p.top, p.right, p.bottom);
  //}
}

void keyPressed() {
  if (key == 's') {
    writeAssignments();
    writeChanges();
  }
}

void writeChanges() {
  println("--------------------------------------------------------------");
  for (AC person : people) {
    for (Paper p : person.primary) {
      // check whether this paper is not in the original list
      if (!person.originalPrimary.contains(p)) {
        println("For " + person.name + " change " + p.paperID + " to 1AC");
      }
    }
    for (Paper p : person.secondary) {
      // check whether this paper is not in the original list
      if (!person.originalSecondary.contains(p)) {
        println("For " + person.name + " change " + p.paperID + " to 2AC");
      }
    }
  }
}

void writeAssignments() {
  //println("in writeAssignments");
  PrintWriter output;
  output = createWriter("assignments.csv");
  for (AC person : people) {
    output.print(person.name + ",primary,");
    for (Paper p : person.primary) {
      output.print(p.paperID + ",");
    }
    output.println("");
    output.print(person.name + ",secondary,");
    for (Paper p : person.secondary) {
      output.print(p.paperID + ",");
    }
    output.println("");
  }
  output.flush();
  output.close();
}

void writeTempAssignments() {
  PrintWriter output;
  output = createWriter("temp-assignments.csv");
  for (AC person : people) {
    output.print(person.name + ",primary,");
    for (Paper p : person.primary) {
      output.print(p.paperID + ",");
    }
    output.println("");
    output.print(person.name + ",secondary,");
    for (Paper p : person.secondary) {
      output.print(p.paperID + ",");
    }
    output.println("");
  }
  output.flush();
  output.close();
}

void mousePressed() {
  dragging = true;
  fromIndex = selectedRow;
  fromSide = selectedSide;
}

void mouseReleased() {
  dragging = false;
  // where did we drop
  AC newAC = people.get(selectedRow);
  AC oldAC = people.get(fromIndex);
  if (oldAC == newAC) {
    // nope
    return;
  }
  if (selectedSide == 1) {
    //println(newAC.name + " 1AC");
    if (newAC.secondary.contains(selectedPaper)) {
      // nope
      return;
    }
    newAC.primary.add(selectedPaper);
    print("Adding 1AC " + selectedPaper.paperID + " to " + newAC.name + ". ");
  } else {
    //println(newAC.name + " 2AC");
    if (newAC.primary.contains(selectedPaper)) {
      // nope
      return;
    }
    newAC.secondary.add(selectedPaper);
    print("Adding 2AC " + selectedPaper.paperID + " to " + newAC.name + ". ");
  }
  if (fromSide == 1) {
    oldAC.primary.remove(selectedPaper);
    println("Removing 1AC " + selectedPaper.paperID + " from " + oldAC.name);
  } else {
    oldAC.secondary.remove(selectedPaper);
    println("Removing 2AC " + selectedPaper.paperID + " from " + oldAC.name);
  }
  writeTempAssignments();
}

// -----------------------------------------------------------------------------

void updateAssignments(String line) {
  String[] parts = split(line, ",");
  if (parts.length < 2) {
    return;
  }

  String namePart = parts[0];
  AC person = null;
  ArrayList<Paper> list;
  String pID;
  for (AC ac : people) {
    if (ac.name.equals(namePart)) {
      person = ac;
    }
  }
  if (person != null) {
    if (parts[1].equals("primary")) {
      list = person.primary;
    } else {
      list = person.secondary;
    }
    list.clear();
    for (int i = 2; i < parts.length - 1; i++) {
      pID = parts[i];
      for (Paper p : papers) {
        if (p.paperID.equals(pID)) {
          list.add(p);
        }
      }
    }
  }
}


void makeACs(String line) {
  String[] parts = split(line, "\t");
  String namePart;
  AC person;
  for (int i = 2; i< parts.length; i+=3) {
    namePart = parts[i];
    if (namePart.length() > 0) {
      println("AC: " + namePart);
      namePart = namePart.substring(1, namePart.length()-14);
      person = new AC(namePart);
      people.add(person);
    }
  }
}

void setDetails(TableRow row) {
  boolean acAssigned = false;

  String id = row.getString(0);
  println("===>", id);
  String title = row.getString(1);
  Paper thisPaper = new Paper(id, title);
  String numberID = id.substring(6, id.length());
  println(numberID);
  //println("Contains " + id + ": " + papers.contains(thisPaper)); 
  for (Paper p : papers) {
    if (p.paperID.equals(numberID)) {
    //if (p.paperTitle.equals(title)) {
      // duplicate, ignore
      //println("paper " + p.paperID + " is a duplicate, ignoring...");
      return;
    }
  }
  papers.add(thisPaper);
  //println("Adding " + id + ":" + title);
  int index;
  int personIndex;
  AC person;
  for (int i = 2; i < row.getColumnCount(); i+=3) {
    index = i;
    personIndex = int((i-2)/3);
    if (personIndex >= people.size()) {
      break;
    }
    person = people.get(personIndex);
    String bid = row.getString(index);
    if (bid.equals("C")) {
      person.conflict.add(thisPaper);
    }
    if (bid.equals("1")) {
      person.want.add(thisPaper);
      thisPaper.wanters.add(person);
    }
    if (bid.equals("2")) {
      person.willing.add(thisPaper);
      thisPaper.willingers.add(person);
    }
    if (bid.equals("3")) {
      person.reluctant.add(thisPaper);
      thisPaper.reluctanters.add(person);
    }
    if (bid.equals("")) {
      person.noBid.add(thisPaper);
      thisPaper.nobidders.add(person);
    }

    index++;
    String stat = row.getString(index);
    if (stat.equals("1AC")) {
      person.primary.add(thisPaper);
      person.originalPrimary.add(thisPaper);
      primaryCount++;
      acAssigned = true;
    }
    if (stat.equals("2AC")) {
      person.secondary.add(thisPaper);
      person.originalSecondary.add(thisPaper);
      secondaryCount++;
    }

    index++;
    String match = row.getString(index);
    String tag = person.name + "|" + thisPaper.paperID;
    matches.put(tag, match);
  }
  if (!acAssigned) {
      println("^^^^^^^^^^^^^^^^^^^^^^^^^^^Paper " + thisPaper.paperID + " has no AC");
  }
}

void printBidSummary() {
  for (Paper p : papers) {
    println(p.paperID + ": Want: " + p.wanters.size() + "\tWilling: " + p.willingers.size() + "\tReluctant: " + p.reluctanters.size() + "\t" + p.paperTitle);
  }
}
