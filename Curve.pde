class Curve
{
    PVector p0, p1, p2, p3;
    ArrayList<PVector> actualPoints;
  
    public Curve(PVector start, PVector end)
    {
        p0 = start;
        p1 = PVector.add(PVector.mult(start,2.0/3), PVector.mult(end,1.0/3));
        p2 = PVector.add(PVector.mult(start,1.0/3), PVector.mult(end,2.0/3));
        p3 = end;
        actualPoints = new ArrayList<PVector>();
    }
  
    public Curve(float x0, float y0,
                 float x1, float y1,
                 float x2, float y2,
                 float x3, float y3)
    {
        p0 = new PVector(x0,y0);
        p1 = new PVector(x1,y1);
        p2 = new PVector(x2,y2);
        p3 = new PVector(x3,y3);
        actualPoints = new ArrayList<PVector>();
    }
  
    public void update(int quality)
    {
        actualPoints = new ArrayList<PVector>();
        for (float t = 0; t <= quality; t++)
        {
            actualPoints.add(pointAt(t / quality));
        }
    }
  
    public void drawSelf(boolean showBounds)
    {
        stroke(0);
        for (int i = 1; i < actualPoints.size(); i++)
        {
          lineBetween(actualPoints.get(i), actualPoints.get(i-1));
        }
        if (showBounds)
        {
            lineBetween(p0,p1);
            lineBetween(p1,p2);
            lineBetween(p2,p3);
        }
    }
    
    public void drawSelf(boolean showBounds, Letter container, int side)
    {
        if (lineThick)
            strokeWeight(4);
        if (showBounds)
        {
            if (!lineWhite)
                stroke(0);
            else
                stroke(255);
            noFill();
            circleAt(container.localToGlobal(p0),POINT_RADIUS);
            lineBetween(container.localToGlobal(p0),container.localToGlobal(p1));
            circleAt(container.localToGlobal(p1),POINT_RADIUS);
            lineBetween(container.localToGlobal(p1),container.localToGlobal(p2));
            circleAt(container.localToGlobal(p2),POINT_RADIUS);
            lineBetween(container.localToGlobal(p2),container.localToGlobal(p3));
            circleAt(container.localToGlobal(p3),POINT_RADIUS);
        }
        
        if (side == -1)
            stroke(255,0,0);
        else if (side == 1)
            stroke(0,0,255);
        else
            stroke(0);
        for (int i = 1; i < actualPoints.size(); i++)
        {
          lineBetween(container.localToGlobal(actualPoints.get(i)), container.localToGlobal(actualPoints.get(i-1)));
        }
        if (lineThick)
            strokeWeight(1);
    }
  
    private PVector pointAt(float t)
    {
        float s0 = pow(1-t,3);
        float s1 = 3 * pow(1-t,2) * t;
        float s2 = 3 * (1-t) * pow(t,2);
        float s3 = pow(t,3);
        
        PVector m1 = PVector.add(PVector.mult(p0,s0),PVector.mult(p1,s1));
        PVector m2 = PVector.add(PVector.mult(p2,s2),PVector.mult(p3,s3));
        return PVector.add(m1,m2);
    }
    
    public PVector getPoint(int index)
    {
        if (index == 0)
            return p0;
        else if (index == 1)
            return p1;
        else if (index == 2)
            return p2;
        else if (index == 3)
            return p3;
        else
            return null;
    }
    
    public void setPoint(int index, PVector newPoint)
    {
        if (index == 0)
            p0 = newPoint;
        else if (index == 1)
            p1 = newPoint;
        else if (index == 2)
            p2 = newPoint;
        else if (index == 3)
            p3 = newPoint;
    }
    
    public String toString()
    {
        String str = "<curve ";
        str += "x0=\"" + p0.x + "\" y0=\"" + p0.y + "\" ";
        str += "x1=\"" + p1.x + "\" y1=\"" + p1.y + "\" ";
        str += "x2=\"" + p2.x + "\" y2=\"" + p2.y + "\" ";
        str += "x3=\"" + p3.x + "\" y3=\"" + p3.y + "\" ";
        str += "/>";
        return str;
    }
    
    public void moveEverything(float dx, float dy)
    {
        PVector disp = new PVector(dx,dy);
        
        p0.add(disp);
        p1.add(disp);
        p2.add(disp);
        p3.add(disp);
        update(10);
    }
}

public void lineBetween(PVector p1, PVector p2)
{
    line(transX(p1.x),transY(p1.y),transX(p2.x),transY(p2.y));
    ///line(p1.x,p1.y,p2.x,p2.y);
}

public void circleAt(PVector c, float r)
{
    ellipse(transX(c.x), transY(c.y), r * 2, r * 2);
}