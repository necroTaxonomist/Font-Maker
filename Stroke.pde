final float POINT_RADIUS = 8;

class Stroke
{
    ArrayList<Curve> curves;
    
    boolean moving;
    int movingCurve;
    int movingPoint;
    
    Letter container;
    
    PVector tempPoint;
    
    public Stroke(Letter c)
    {
        curves = new ArrayList<Curve>();
        container = c;
        moving = false;
    }
    
    public void act()
    {
        if (moving)
        {
            if (!(mousePressed && mouseButton == LEFT))
                moving = false;
            else
            {
                PVector mp = new PVector(reverseX(mouseX), reverseY(mouseY));
                PVector lmp = container.globalToLocal(mp);
                curves.get(movingCurve).setPoint(movingPoint,lmp);
                curves.get(movingCurve).update(10);
                if (movingPoint == 0 && movingCurve > 0)
                {
                    curves.get(movingCurve-1).setPoint(3,lmp);
                    curves.get(movingCurve-1).update(10);
                }
                if (movingPoint == 3 && movingCurve < curves.size()-1)
                {
                    curves.get(movingCurve+1).setPoint(0,lmp);
                    curves.get(movingCurve+1).update(10);
                }
            }
        }
    }
    
    public void processClick()
    {
        float mx = reverseX(mouseX);
        float my = reverseY(mouseY);
        PVector mp = new PVector(mx,my);
        PVector lmp = container.globalToLocal(mp);
        
        for (int c = 0; c < curves.size(); c++)
        {
            for (int p = 0; p < 4; p++)
            {
                PVector test = container.localToGlobal(curves.get(c).getPoint(p));
                if (PVector.dist(test,mp) <= reverseH(1.2*POINT_RADIUS))
                {
                    moving = true;
                    movingCurve = c;
                    movingPoint = p;
                    return;
                }
            }
        }
        newCurve(lmp);
    }
    
    public void processRightClick()
    {
        float mx = reverseX(mouseX);
        float my = reverseY(mouseY);
        PVector mp = new PVector(mx,my);
        
        if (curves.size() > 0)
        {
            PVector test = container.localToGlobal(curves.get(curves.size()-1).getPoint(3));
            if (PVector.dist(test,mp) <= 1.2*POINT_RADIUS)
            {
                curves.remove(curves.size()-1);
            }
        }
    }
    
    private void newCurve(PVector p)
    {
        //println(p);
        if (curves.size() == 0)
        {
            if (tempPoint == null)
            {
                 tempPoint = p;
            }
            else
            {
                curves.add(new Curve(tempPoint, p));
                tempPoint = null;
                curves.get(curves.size()-1).update(10);
            }
        }
        else
        {
            PVector prevPoint = curves.get(curves.size()-1).getPoint(3);
            curves.add(new Curve(prevPoint, p));
            curves.get(curves.size()-1).update(10);
        }
    }
    
    
    
    public void drawSelf(boolean showBounds, int side)
    {
        for (int c = 0; c < curves.size(); c++)
        {
            //println(curves.get(c));
            curves.get(c).drawSelf(showBounds, container, side);
        }
    }
    
    public String toString()
    {
        String str = "<stroke>\n";
        for (Curve c : curves)
        {
            str += c;
            str += "\n";
        }
        str += "</stroke>";
        return str;
    }
    
    public void add(Curve c)
    {
        curves.add(c);
    }
    
    public void moveEverything(float dx, float dy)
    {
        for (Curve c : curves)
            c.moveEverything(dx,dy);
    }
}