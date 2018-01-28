float viewX, viewY, viewW, viewH;

ArrayList<Letter> letters;

TextInput console;
boolean consoleActive;
int consolePurpose;

PImage bg;
String bgFn;

float spacing;
float thickness;

String bgDir = "C:/Users/necro/Desktop/Dev/C/BIGASSPROJECT/Related Media/Handwriting/";
String fontsDir = "C:/Users/necro/Desktop/Dev/C/BIGASSPROJECT/ScribbledInTheMargins/xml/font/";

boolean lineWhite;
boolean lineThick;

ArrayList<Integer> ruleIndices;
ArrayList<String> rules;


void setup()
{
    size(960,960);
    viewX = 0;
    viewY = 0;
    viewW = 960;
    viewH = 960;
    letters = new ArrayList<Letter>();
    bg = null;
    spacing = 1.0;
    thickness = 1.0;
    ruleIndices = new ArrayList<Integer>();
    rules = new ArrayList<String>();
    console = new TextInput();
    consoleActive = false;
    
    lineWhite = false;
    lineThick = false;
}

void draw()
{
    background(255);
    if (bg != null)
        image(bg, transX(0), transY(0), transW(bg.width), transH(bg.height));
    
    stroke(0);
    fill(255);
    for (int i = 1; i <=9; i++)
        rect(width - 2*i*BORDER - 2*i*BUTTON, 2*BORDER, 2*BUTTON, 2*BUTTON);
    
    noStroke();
    fill(0);
    textSize(2*BUTTON);
    textAlign(CENTER,TOP);
    text("L", width - 2*BORDER - BUTTON, 2*BORDER);
    text("S", width - 4*BORDER - 3*BUTTON, 2*BORDER);
    text("i", width - 6*BORDER - 5*BUTTON, 2*BORDER);
    text("x", width - 8*BORDER - 7*BUTTON, 2*BORDER);
    text("m", width - 10*BORDER - 9*BUTTON, 2*BORDER);
    text("=", width - 12*BORDER - 11*BUTTON, 2*BORDER);
    text("_", width - 14*BORDER - 13*BUTTON, 2*BORDER);
    text("T", width - 16*BORDER - 15*BUTTON, 2*BORDER);
    text("R", width - 18*BORDER - 17*BUTTON, 2*BORDER);
    
    for(int l = 0; l < letters.size(); l++)
    {
        if (letters.get(l).killMe)
        {
            letters.remove(l);
            l--;
        }
        else
        {
            letters.get(l).act();
            letters.get(l).drawSelf();
        }
    }
    
    if (mousePressed && mouseButton == CENTER)
    {
        float dx = reverseX(mouseX) - reverseX(pmouseX);
        float dy = reverseY(mouseY) - reverseY(pmouseY);
        viewX -= dx;
        viewY -= dy;
    }
}

void mouseWheel(MouseEvent event)
{
    float e = event.getCount();
    if (keyPressed && keyCode == CONTROL)
    {
        //println("what fuck");
        viewX -= 10 * e;
        viewY -= 10 * e;
        viewH += 20 * e;
        viewW += 20 * e;
    }
}

void mousePressed()
{
    if (mouseButton == LEFT)
    {
        for (int i = 1; i <=9; i++)
        {
            if (withinRect(width - (2*i)*(BORDER + BUTTON), 2*BORDER, 2*BUTTON, 2*BUTTON, mouseX, mouseY))
            {
                if (i == 6)
                    equalLetters();
                else
                    activateConsole(i);
                return;
            }
        }
        
        int index = -1;
        int place = -1;
        for (int i = 0; i < letters.size(); i++)
        {
            place = letters.get(i).hitboxClicked();
            if (place != 0)
            {
                index = i;
                break;
            }
        }
        if (index == -1)
            letters.add(new Letter(reverseX(mouseX), reverseY(mouseY)));
        else
            letters.get(index).processClick(place);
    }
    else if (mouseButton == RIGHT)
    {
        int index = -1;
        int place = -1;
        for (int i = 0; i < letters.size(); i++)
        {
            place = letters.get(i).hitboxClicked();
            if (place != 0)
            {
                index = i;
                break;
            }
        }
        if (index != -1)
            letters.get(index).processRightClick(place);
    }
        
}

void keyPressed()
{
    if (consoleActive)
    {
        if (key == CODED)
        {
        }
        else if (key == BACKSPACE)
        {
            console.back();
            println(console);
        }
        else if (key == ENTER)
        {
            String input = console.enter();
            println(console);
            interpretConsole(input);
        }
        else
        {
            console.add(key);
            println(console);
        }
    }
    else
    {
        if (key == 'w')
        {
            viewY -= reverseH(height/20);
        }
        else if (key == 'a')
        {
            viewX -= reverseW(height/20);
        }
        else if (key == 's')
        {
            viewY += reverseH(height/20);
        }
        else if (key == 'd')
        {
            viewX += reverseW(height/20);
        }
        else if (key == 'q' || key == 'e')
        {
            int e = 1;
            if (key == 'e')
                e *= -1;
            viewX -= 10 * e;
            viewY -= 10 * e;
            viewH += 20 * e;
            viewW += 20 * e;
        }
        else if (key == '1')
        {
            if (lineWhite)
                lineWhite = false;
            else
                lineWhite = true;
        }
        else if (key == '2')
        {
            if (lineThick)
                lineThick = false;
            else
                lineThick = true;
        }
    }
}

void activateConsole(int purpose)
{
    consoleActive = true;
    consolePurpose = purpose;
}

void interpretConsole(String input)
{
    consoleActive = false;
    if (consolePurpose == 9)
        setRule(input);
    else if (consolePurpose == 8)
        setThickness(input);
    else if (consolePurpose == 7)
        setSpacing(input);
    else if (consolePurpose == 5)
        moveLetters(input);
    else if (consolePurpose == 4)
        scaleLetters(input);
    else if (consolePurpose == 3)
    {
        bg = loadImage(bgDir + input);
        bgFn = bgDir + input;
    }
    else if (consolePurpose == 2)
    {
        if (!input.equals(""))
            println(exportToXML(fontsDir + input));
    }
    else if (consolePurpose == 1)
    {
        XMLReader r = new XMLReader();
        r.load(fontsDir + input);
        letters = r.read();
    }
}

String exportToXML(String fn)
{
    String str = "";
    if (bg != null)
    {
        str += "<bg>";
        str += bgFn;
        str += "</bg>\n";
    }
    
    if (spacing != 1.0)
    {
        str += "<spacing>";
        str += spacing;
        str += "</spacing>\n";
    }
    
    if (thickness != 1.0)
    {
        str += "<thickness>";
        str += thickness;
        str += "</thickness>\n";
    }
    
    for (int i = 0; i < ruleIndices.size(); ++i)
    {
        str += "<rule var=\"";
        str += ruleIndices.get(i);
        str += "\">";
        str += rules.get(i);
        str += "</rule>\n";
    }
    
    for (Letter l : letters)
    {
        str += l;
        str += "\n";
    }
    
    PrintWriter output = createWriter(fn);
    output.print(str);
    output.flush();
    output.close();
    
    return str;
}

void setRule(String list)
{
    int tildePos = list.indexOf("~");
    
    String indexString = list.substring(0,tildePos);
    String ruleString = list.substring(tildePos+1);
    
    int index = Integer.parseInt(indexString);
    
    int usingIndex = 0;
    for (int i = 0; i < ruleIndices.size(); ++i)
    {
        if (ruleIndices.get(i) == index)
        {
            usingIndex = i;
            break;
        }
    }
    if (usingIndex >= ruleIndices.size())
    {
        ruleIndices.add(index);
        rules.add("");
    }
    
    rules.set(usingIndex,ruleString);
}

void setThickness(String num)
{
    thickness = Float.parseFloat(num);
}

void setSpacing(String num)
{
    spacing = Float.parseFloat(num);
}

void moveLetters(String list)
{
    int tildePos = list.indexOf("~");
    String sfString = list.substring(tildePos+1);
    float m = Float.parseFloat(sfString);
    for (int i = 0; i < tildePos; ++i)
    {
        int lookFor = (int)(list.charAt(i));
        //System.out.println("looking for " + lookFor);
        for (Letter l : letters)
        {
            if (l.value == lookFor)
            {
                l.moveEverything(m,0);
                break;
            }
        }
    }
    System.out.println("Moved by " + m);
}

void scaleLetters(String list)
{
    int tildePos = list.indexOf("~");
    String sfString = list.substring(tildePos+1);
    float sf = Float.parseFloat(sfString);
    if (tildePos == 0)
    {
        for (Letter l : letters)
            l.scaleByFactor(sf);
    }
    else
    {
        for (int i = 0; i < tildePos; ++i)
        {
            int lookFor = (int)(list.charAt(i));
            //System.out.println("looking for " + lookFor);
            for (Letter l : letters)
            {
                if (l.value == lookFor)
                {
                    l.scaleByFactor(sf);
                    break;
                }
            }
        }
    }
    System.out.println("Scaled by " + sf);
}

void equalLetters()
{
    float smallest = 0;
    float baseSF = 1.0;
    for (Letter l : letters)
    {
        if (smallest == 0 || l.getHeight() < smallest)
        {
            smallest = l.getHeight();
            baseSF = l.getScale();
        }
    }
    for (Letter l : letters)
    {
        float scale = l.getHeight() / smallest;
        l.scaleByFactor(scale * baseSF);
    }
}

PVector transP(PVector p)
{
    float nx = transX(p.x);
    float ny = transY(p.y);
    return new PVector(nx,ny);
}

float transX(float x)
{
    return width * ((x - viewX) / viewW);
}

float transY(float y)
{
    return height * ((y - viewY) / viewH);
}

float transW(float x)
{
    return width * (x / viewW);
}

float transH(float y)
{
    return height * (y / viewH);
}

float reverseX(float x)
{
    return (viewW / width) * x + viewX;
}

float reverseY(float y)
{
    return (viewH / height) * y + viewY;
}

float reverseW(float x)
{
    return viewW * (x / height);
}

float reverseH(float y)
{
    return viewH * (y / height);
}

boolean withinRect(float x, float y, float w, float h, float testX, float testY)
{
    return testX >= x && testX < x + w && testY >= y && testY < y + h;
}