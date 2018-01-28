class TextInput
{
    String log;
    String input;
    
    public TextInput()
    {
        log = "";
        input = "";
    }
    
    public void add(char in)
    {
        input += in;
    }
    
    public void back()
    {
        if (input.length() > 0)
            input = input.substring(0,input.length()-1);
    }
    
    public String enter()
    {
        log += ">  " + input + "\n";
        String str = input;
        input = "";
        return str;
    }
    
    public String toString()
    {
        return "  >  " + input;
    }
}