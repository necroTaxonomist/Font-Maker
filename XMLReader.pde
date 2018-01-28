class XMLReader
{
    ArrayList<Letter> letters;
    Letter currentLetter;
    Stroke currentStroke;
    
    XMLTag root;
    
    public boolean load(String fn)
    {
        String input = "";
        
        try
        {
            BufferedReader br = createReader(fn);
            String line;
            do
            {
                try
                {
                    line = br.readLine();
                }
                catch (Exception e)
                {
                    return false;
                }
                input += line + "\n";
            }
            while (line != null);
            br.close();
            root = new XMLTag("root", new ArrayList<String>(), input);
            
            return true;
        }
        catch (IOException e)
        {
            return false;
        }
    }
    
    public boolean load(XMLTag input)
    {
        root = input;
        return true;
    }
    
    public ArrayList<Letter> read()
    {
        letters = new ArrayList<Letter>();
        readTag(root);
        return letters;
    }
    
    public void readTag(XMLTag tag)
    {
        if (tag == null)
        {
            println("Now ya fucked up! You have fucked up now!");
            return;
        }
        if (tag.getTitle().equals("letter"))
        {
            int val = sti(tag.getArg(0));
            int var = sti(tag.getArg(1));
            float x = stf(tag.getArg(2));
            float y = stf(tag.getArg(3));
            float w = stf(tag.getArg(4));
            float h = stf(tag.getArg(5));
            float[] b = {stf(tag.getArg(6)), stf(tag.getArg(7)), stf(tag.getArg(8)), stf(tag.getArg(9))};
            float sf = stf(tag.getArg(10));
            currentLetter = new Letter(val,var,x,y,w,h,b);
            letters.add(currentLetter);
            currentLetter.scaleByFactor(sf);
        }
        else if (tag.getTitle().equals("stroke"))
        {
            currentStroke = new Stroke(currentLetter);
            currentLetter.addStroke(currentStroke);
        }
        else if (tag.getTitle().equals("curve"))
        {
            float x0 = stf(tag.getArg(0)); float y0 = stf(tag.getArg(1));
            float x1 = stf(tag.getArg(2)); float y1 = stf(tag.getArg(3));
            float x2 = stf(tag.getArg(4)); float y2 = stf(tag.getArg(5));
            float x3 = stf(tag.getArg(6)); float y3 = stf(tag.getArg(7));
            Curve currentCurve = new Curve(x0,y0,x1,y1,x2,y2,x3,y3);
            currentCurve.update(10);
            currentStroke.add(currentCurve);
        }
        else if (tag.getTitle().equals("bg"))
        {
            bg = loadImage(tag.getContents());
            bgFn = tag.getContents();
        }
        else if (tag.getTitle().equals("spacing"))
        {
            spacing = stf(tag.getContents());
        }
        else if (tag.getTitle().equals("thickness"))
        {
            thickness = stf(tag.getContents());
        }
        else if (tag.getTitle().equals("rule"))
        {
            setRule(tag.getArg(0) + "~" + tag.getContents());
        }
        
        if (tag.getTags().size() > 0)
        {
            for (XMLTag t : tag.getTags())
            {
                readTag(t);
            }
        }
    }
}