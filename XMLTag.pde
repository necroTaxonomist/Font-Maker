class XMLTag
{
    private String title;
    private ArrayList<String> arguments;
    private boolean emptyElement;
    private String contents;
    private ArrayList<XMLTag> containedTags;
    
    public XMLTag(String titleIn, ArrayList<String> argumentsIn, String contentsIn)
    {
        title = titleIn;
        arguments = argumentsIn;
        emptyElement = false;
        contents = "";
        containedTags = new ArrayList<XMLTag>();
        
        int curPos = 0;
        while (curPos < contentsIn.length())
        {
            String tag = getTagAtPos(contentsIn, curPos);
            if (tag.equals("NOTAG"))
            {
                if (contentsIn.charAt(curPos) != '\n' && contentsIn.charAt(curPos) != '\t')
                    contents += contentsIn.charAt(curPos);
                curPos++;
            }
            else
            {
                String tempTitle = getTagTitle(tag);
                ArrayList<String> tempArgs = getTagArgs(tag);
                boolean tempEmpty = getTagIsEmpty(tag);
                if (tempEmpty)
                {
                    containedTags.add(new XMLTag(tempTitle,tempArgs));
                    
                    curPos += tag.length();
                }
                else
                {
                    int cStart = curPos + tag.length();
                    int cEnd = findCloseTag(contentsIn, tempTitle, cStart);
                    
                    String tempContents = contentsIn.substring(cStart,cEnd);
                    
                    containedTags.add(new XMLTag(tempTitle,tempArgs,tempContents));
                    
                    curPos = cEnd + tempTitle.length() + 3;
                }
            }
        }
    }
    
    public XMLTag(String titleIn, ArrayList<String> argumentsIn)
    {
        title = titleIn;
        arguments = argumentsIn;
        emptyElement = true;
        contents = "";
        containedTags = new ArrayList<XMLTag>();
    }
    
    public String toString()
    {
        String returnString = "<";
        returnString += title;
        for (int i = 0; i < arguments.size(); i++)
        {
            returnString += " arg";
            returnString += i;
            returnString += "=\"";
            returnString += arguments.get(i);
            returnString += "\"";
        }
        if (emptyElement)
            returnString += " />";
        else
        {
            returnString += ">";
            if (!contents.equals("") && !contents.equals("null"))
            {
                returnString += contents;
            }
            for (int j = 0; j < containedTags.size(); j++)
            {
                returnString += "\n";
                returnString += containedTags.get(j);
            }
            if (containedTags.size() > 0)
                returnString += "\n";
            returnString += "</";
            returnString += title;
            returnString += ">";
        }
        return returnString;
    }
    
    public String getTitle() { return title; }
    public ArrayList<XMLTag> getTags() { return containedTags; }
    public String getContents() { return contents; }
    public String getArg(int index) { return arguments.get(index); }
}

public int sti(String str)
{
    return Integer.parseInt(str);
}

public float stf(String str)
{
    return Float.parseFloat(str);
}

public String getTagAtPos(String str, int pos)
{
    if (str.charAt(pos) != '<')
        return "NOTAG";
    else
    {
        int endIndex = str.indexOf('>',pos) + 1;
        return str.substring(pos,endIndex);
    }
}

public String getTagTitle(String tag)
{
    int endIndex = tag.indexOf(' ');
    if (endIndex == -1)
        endIndex = tag.indexOf('>');
    return tag.substring(1,endIndex);
}

public static int findCloseTag(String str, String tagTitle, int startPos)
{
    String searchFor = "</" + tagTitle + ">";
    int foundIndex = str.indexOf(searchFor,startPos);
    return foundIndex;
}

public boolean getTagIsEmpty(String tag)
{
    int curPos = 0;
    int slashIndex = -1;
    while(true)
    {
        slashIndex = tag.indexOf('/',curPos);
        if (slashIndex == -1)
            return false;
        else
        {
            boolean atEnd = true;
            for (int i = slashIndex + 1; i < tag.length() - 1; i++)
            {
                if (tag.charAt(i) != ' ')
                    atEnd = false;
            }
            if (atEnd)
                return true;
            else
                curPos = slashIndex + 1;
        }
    }
}

public ArrayList<String> getTagArgs(String tag)
{
    ArrayList<String> args = new ArrayList<String>();
    int curPos = 0;
    int argIndex = -1;
    while(true)
    {
        argIndex = tag.indexOf('=',curPos);
        if (argIndex == -1)
            break;
        else
        {
            int argBegin = tag.indexOf('"',argIndex);
            int argEnd = tag.indexOf('"',argBegin+1);
            curPos = argEnd + 1;
            String newArg = tag.substring(argBegin+1,argEnd);
            args.add(newArg);
        }
    }
    return args;
}