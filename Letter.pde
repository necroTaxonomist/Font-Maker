final float BORDER = 4;
final float BUTTON = 24;

class Letter
{
    final int INSIDE_CLICK = 1;
    final int BORDER_CLICK = 2;
    final int FIRST_NUMBER_CLICK = 3;
    final int SECOND_NUMBER_CLICK = 4;
    final int STROKE_CLICK = 5;
    final int THIRD_NUMBER_CLICK = 6;
    final int PRINT_CLICK = 7;
    final int HANDLE_CLICK = 8;
    
    float x, y, w, h;
    float[] borders;
    int value;
    int variant;
    boolean active;
    boolean resizing;
    boolean moving;
    int movingBorders;
    ArrayList<Stroke> strokes;
    int activeStroke;
    boolean firstResize;
    boolean killMe;
    float scaleFactor;
    
    public Letter(float xIn, float yIn)
    {
        x = xIn;
        y = yIn;
        w = 0;
        h = 0;
        borders = new float[4];
        active = false;
        resizing = true;
        movingBorders = -1;
        strokes = new ArrayList<Stroke>();
        activeStroke = -1;
        firstResize = true;
        killMe = false;
        scaleFactor = 1.0;
    }
    
    public Letter(float xIn, float yIn, float wIn, float hIn)
    {
        x = xIn;
        y = yIn;
        w = wIn;
        h = hIn;
        borders = new float[4];
        active = false;
        resizing = false;
        movingBorders = -1;
        strokes = new ArrayList<Stroke>();
        activeStroke = -1;
        killMe = false;
        scaleFactor = 1.0;
    }
    
    public Letter(int valIn, int varIn, float xIn, float yIn, float wIn, float hIn, float[] b)
    {
        value = valIn;
        variant = varIn;
        x = xIn;
        y = yIn;
        w = wIn;
        h = hIn;
        borders = b;
        active = false;
        resizing = false;
        movingBorders = -1;
        strokes = new ArrayList<Stroke>();
        activeStroke = -1;
        killMe = false;
        scaleFactor = 1.0;
    }
    
    public void act()
    {
        for (int s = 0; s < strokes.size(); s++)
        {
            strokes.get(s).act();
            if (onScreen())
                strokes.get(s).drawSelf(active && s == activeStroke, -1);
        }
        
        if (resizing)
        {
            if (!mousePressed)
            {
                resizing = false;
                if (firstResize)
                    firstResize = false;
            }
            else
            {
                w = max(0,reverseX(mouseX) - x);
                h = max(0,reverseY(mouseY) - y);
            }
        }
        if (moving)
        {
            if (!mousePressed)
                moving = false;
            else
            {
                x += reverseX(mouseX) - reverseX(pmouseX);
                y += reverseY(mouseY) - reverseY(pmouseY);
            }
        }
        if (movingBorders != -1)
        {
            if (!mousePressed)
                movingBorders = -1;
            else
            {
                if (movingBorders == 0)
                    borders[0] += reverseX(mouseX) - reverseX(pmouseX);
                else if (movingBorders == 1)
                    borders[1] -= reverseY(mouseY) - reverseY(pmouseY);
                else if (movingBorders == 2)
                    borders[2] -= reverseX(mouseX) - reverseX(pmouseX);
                else if (movingBorders == 3)
                    borders[3] += reverseY(mouseY) - reverseY(pmouseY);
            }
            
        }
        int hbStatus = hitboxClicked();
        if (hbStatus > 0)
            active = true;
        else
            active = false;
    }
    
    public void drawSelf()
    {
        noStroke();
        
        //inside
        if (active)
            fill(255,128,128);
        else
            fill(0,0,0);
        rect(transX(x+w), transY(y)-BORDER, BORDER, transH(h) + 2*BORDER);
        rect(transX(x)-BORDER, transY(y)-BORDER, BORDER, transH(h) + 2*BORDER);
        rect(transX(x), transY(y)-BORDER, transW(w), BORDER);
        rect(transX(x), transY(y+h), transW(w), BORDER);
        
        //outside
        if (active)
            fill(255,0,0);
        else
            fill(0,0,0);
        rect(transX(x+w+borders[0]), transY(y-borders[1])-BORDER, BORDER, transH(h+borders[1]+borders[3]) + 2*BORDER);
        rect(transX(x-borders[2])-BORDER, transY(y-borders[1])-BORDER, BORDER, transH(h+borders[1]+borders[3]) + 2*BORDER);
        rect(transX(x-borders[2]), transY(y-borders[1])-BORDER, transW(w+borders[0]+borders[2]), BORDER);
        rect(transX(x-borders[2]), transY(y+h+borders[3]), transW(w+borders[0]+borders[2]), BORDER);
        
        //handles
        if (active)
            fill(255,0,0);
        else
            fill(0,0,0);
        rect(transX(x+w+borders[0]) + 2*BORDER, transY(y-borders[1]+h/4)-BORDER, BORDER, transH((h+borders[1]+borders[3])/2) + BORDER);
        rect(transX(x-borders[2])-3*BORDER, transY(y-borders[1]+h/4)-BORDER, BORDER, transH((h+borders[1]+borders[3])/2) + BORDER);
        rect(transX(x-borders[2]+w/4), transY(y-borders[1])-3*BORDER, transW((w+borders[0]+borders[2])/2), BORDER);
        rect(transX(x-borders[2]+w/4), transY(y+h+borders[3])+2*BORDER, transW((w+borders[0]+borders[2])/2), BORDER);
        
        //rect(transX(x+w+BORDER), transY(y-3*BORDER), transW(2*BORDER), transH(2*BORDER));
        
        //numbers
        fill(240);
        rect(transX(x-borders[2])-BORDER, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER);
        rect(transX(x-borders[2])+BUTTON, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER);
        rect(transX(x-borders[2])+2*BUTTON+2*BORDER, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER);
        
        fill(0);
        textSize(BUTTON+2*BORDER);
        textAlign(CENTER,CENTER);
        text(firstDigit(), transX(x-borders[2])-BORDER+.5*BUTTON, transY(y-borders[1]) - (BUTTON+2*BORDER) / 2 - 4*BORDER);
        text(secondDigit(), transX(x-borders[2])+BUTTON+.5*BUTTON, transY(y-borders[1]) - (BUTTON+2*BORDER) / 2 - 4*BORDER);
        text(thirdDigit(), transX(x-borders[2])+2*BUTTON+2*BORDER+.5*BUTTON, transY(y-borders[1]) - (BUTTON+2*BORDER) / 2 - 4*BORDER);
        
        //scale
        fill(192);
        textSize(BUTTON);
        textAlign(LEFT,TOP);
        text(scaleFactor, transX(x-borders[2]), transY(y-borders[1]));
        
        fill(255,0,0);
        
        for (int i = 0; i <= strokes.size(); i++)
        {
            float sca = 1.0;
            if (i == strokes.size())
                sca = .8;
            float offset = (1-sca)*BUTTON/2;
            
            rect(transX(x-borders[2])+3*BUTTON+4*BORDER + offset + 7*BORDER*i, transY(y-borders[1]) - 4*BORDER - BUTTON + offset, sca*BUTTON, sca*BUTTON);
        }
        
        if (activeStroke != -1)
        {
            noFill();
            stroke(255,0,255);
            float sca = 1.0;
            int i = activeStroke;
            rect(transX(x-borders[2])+3*BUTTON+4*BORDER + 7*BORDER*i, transY(y-borders[1]) - 4*BORDER - BUTTON, sca*BUTTON, sca*BUTTON);
        }
    }
    
    private String firstDigit()
    {
        int sixteens = value / 16;
        if (sixteens < 10)
            return "" + sixteens;
        else if (sixteens == 10)
            return "A";
        else if (sixteens == 11)
            return "B";
        else if (sixteens == 12)
            return "C";
        else if (sixteens == 13)
            return "D";
        else if (sixteens == 14)
            return "E";
        else if (sixteens == 15)
            return "F";
        else
            return "?";
    }
    
    private String secondDigit()
    {
        int ones = value % 16;
        if (ones < 10)
            return "" + ones;
        else if (ones == 10)
            return "A";
        else if (ones == 11)
            return "B";
        else if (ones == 12)
            return "C";
        else if (ones == 13)
            return "D";
        else if (ones == 14)
            return "E";
        else if (ones == 15)
            return "F";
        else
            return "?";
    }
    
    private String thirdDigit()
    {
        int ones = variant % 16;
        if (ones < 10)
            return "" + ones;
        else if (ones == 10)
            return "A";
        else if (ones == 11)
            return "B";
        else if (ones == 12)
            return "C";
        else if (ones == 13)
            return "D";
        else if (ones == 14)
            return "E";
        else if (ones == 15)
            return "F";
        else
            return "?";
    }
    
    public int hitboxClicked()
    {
        float mx = mouseX;
        float my = mouseY;
        
        if (withinRect(transX(x-borders[2]),transY(y-borders[1]),transW(w+borders[0]+borders[2]),transH(h+borders[1]+borders[3]),mx,my))
            return INSIDE_CLICK;
        else if (withinRect(transX(x-borders[2])-BORDER,transY(y-borders[1])-BORDER,transW(w+borders[0]+borders[2])+2*BORDER,transH(h+borders[1]+borders[3])+2*BORDER,mx,my))
            return BORDER_CLICK;
        else if (withinRect(transX(x-borders[2])-BORDER, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER, mx, my))
        {
            //////println("3");
            return FIRST_NUMBER_CLICK;
        }
        else if (withinRect(transX(x-borders[2])+BUTTON, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER, mx, my))
        {
            //////println("4");
            return SECOND_NUMBER_CLICK;
        }
        else if (withinRect(transX(x-borders[2])+2*BUTTON+2*BORDER, transY(y-borders[1]) - (BUTTON+2*BORDER) - 3*BORDER, BUTTON, BUTTON+2*BORDER, mx, my))
        {
            return THIRD_NUMBER_CLICK;
        }
        else if (withinRect(transX(x+w+BORDER), transY(y-3*BORDER), transW(2*BORDER), transH(2*BORDER), mx, my))
            return PRINT_CLICK;
        else
        {
            for (int i = 0; i <= strokes.size(); i++)
            {
                float sca = 1.0;
                if (i == strokes.size())
                    sca = .8;
                float offset = (1-sca)*BUTTON/2;
                
                if (withinRect(transX(x-borders[2])+3*BUTTON+4*BORDER + offset + 7*BORDER*i, transY(y-borders[1]) - 4*BORDER - BUTTON + offset, sca*BUTTON, sca*BUTTON, mx, my))
                    return STROKE_CLICK;
            }
            
            if (withinRect(transX(x+w+borders[0]) + 2*BORDER, transY(y-borders[1]+h/4)-BORDER, BORDER, transH((h+borders[0]+borders[2])/2) + BORDER, mx, my))
            {
                return HANDLE_CLICK;
            }
            else if (withinRect(transX(x-borders[2]+w/4), transY(y-borders[1])-3*BORDER, transW((w+borders[1]+borders[3])/2), BORDER, mx, my))
            {
                return HANDLE_CLICK+1;
            }
            else if (withinRect(transX(x-borders[2])-3*BORDER, transY(y-borders[1]+h/4)-BORDER, BORDER, transH((h+borders[0]+borders[2])/2) + BORDER, mx, my))
            {
                return HANDLE_CLICK+2;
            }
            else if (withinRect(transX(x-borders[2]+w/4), transY(y+h+borders[3])+2*BORDER, transW((w+borders[1]+borders[3])/2), BORDER, mx, my))
            {
                return HANDLE_CLICK+3;
            }
        }
        
        return 0;
    }
    
    public void incrementFirst()
    {
        value += 16;
        if (value / 16 >= 16)
            value -= 256;
    }
    
    public void incrementSecond()
    {
        if (value % 16 == 15)
            value -= 15;
        else
            value += 1;
    }
    
    public void incrementThird()
    {
        if (variant % 16 == 15)
            variant -= 15;
        else
            variant += 1;
    }
    
    public void processClick(int place)
    {
        float mx = mouseX;
        float my = mouseY;
        if (place == INSIDE_CLICK)
        {
            if (activeStroke > -1)
            {
                strokes.get(activeStroke).processClick();
            }
        }
        else if (place == BORDER_CLICK)
        {
            if (reverseX(mouseX) < x || reverseY(mouseY) < y)
                moving = true;
            else
                resizing = true;
        }
        else if (place == FIRST_NUMBER_CLICK)
        {
            //////println("did 3");
            incrementFirst();
        }
        else if (place == SECOND_NUMBER_CLICK)
        {
            ////println("did 4");
            incrementSecond();
        }
        else if (place == THIRD_NUMBER_CLICK)
        {
            incrementThird();
        }
        else if (place == STROKE_CLICK)
        {
            //////println("did 5");
            for (int i = 0; i <= strokes.size(); i++)
            {
                float sca = 1.0;
                if (i == strokes.size())
                    sca = .8;
                float offset = (1-sca)*BUTTON/2;

                if (withinRect(transX(x-borders[2])+3*BUTTON+4*BORDER + offset + 7*BORDER*i, transY(y-borders[1]) - 4*BORDER - BUTTON + offset, sca*BUTTON, sca*BUTTON, mx, my))
                {
                    if (i == strokes.size())
                        strokes.add(new Stroke(this));
                    activeStroke = i;
                }
            }
        }
        else if (place == PRINT_CLICK)
            println(this);
        else if (place >= HANDLE_CLICK && place <= HANDLE_CLICK+3)
        {
            movingBorders = place - HANDLE_CLICK;
        }
    }
    
    public void processRightClick(int place)
    {
        float mx = mouseX;
        float my = mouseY;
        if (place == INSIDE_CLICK)
        {
            if (activeStroke > -1)
            {
                strokes.get(activeStroke).processRightClick();
            }
        }
        else if (place == BORDER_CLICK)
        {
            killMe = true;
        }
        else if (place == STROKE_CLICK)
        {
            //////println("did 5");
            for (int i = 0; i < strokes.size(); i++)
            {
                float sca = 1.0;
                float offset = (1-sca)*BUTTON/2;

                if (withinRect(transX(x-borders[2])+3*BUTTON+4*BORDER + offset + 7*BORDER*i, transY(y-borders[1]) - 4*BORDER - BUTTON + offset, sca*BUTTON, sca*BUTTON, mx, my))
                {
                    strokes.remove(i);
                    activeStroke = -1;
                }
            }
        }
    }
    
    public PVector localToGlobal(PVector p)
    {
        float nx = x + p.x * h;
        float ny = (y + h) - p.y * h;
        
        return new PVector(nx,ny);
    }
    
    public PVector globalToLocal(PVector n)
    {
        float px = (n.x - x) / h;
        float py = (n.y - (y + h)) / h * -1;
        
        return new PVector(px,py);
    }
    
    public String toString()
    {
        String str = "<letter ";
        str += "val=\"" + value + "\" ";
        str += "var=\"" + variant + "\" ";
        
        str += "x=\"" + x + "\" ";
        str += "y=\"" + y + "\" ";
        str += "w=\"" + w + "\" ";
        str += "h=\"" + h + "\" ";
        
        str += "rb=\"" + borders[0] + "\" ";
        str += "tb=\"" + borders[1] + "\" ";
        str += "lb=\"" + borders[2] + "\" ";
        str += "bb=\"" + borders[3] + "\" ";
        str += "sf=\"" + scaleFactor + "\">\n";
        
        for (Stroke s : strokes)
        {
            str += s;
            str += "\n";
        }
        
        str += "</letter>";
        return str;
    }
    
    public void addStroke(Stroke s)
    {
        strokes.add(s);
    }
    
    public void scaleByFactor(float factor)
    {
        scaleFactor = factor;
    }
    
    public void moveEverything(float dx, float dy)
    {
        for (Stroke s : strokes)
            s.moveEverything(dx,dy);
    }
    
    public boolean onScreen()
    {
        if (transX(x-borders[2]) > width)
            return false;
        else if (transY(y-borders[1]) > height)
            return false;
        else if (transX(x+w+borders[0]) < 0)
            return false;
        else if (transY(y+h+borders[3]) < 0)
            return false;
        else
            return true;
    }
    
    public float getHeight() { return h; }
    
    public float getScale() { return scaleFactor; }
}