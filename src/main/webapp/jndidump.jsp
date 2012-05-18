<%-- 
    Document   : dumpjndi.jsp
    Created on : May 8, 2008, 7:19:38 PM
    Author     : Jamie Raut (http://jamieraut.blogspot.com/)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="javax.naming.*,java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%! 

   /* Something silly to use to visually distinguish different levels within the
    * naming hierarchy.
    */

    private static final String INDENT = "    ";

    
   /* Recursively prints the contents of a naming context and all subcontexts.
    */
    
    void printNode(Context context, String name, int indentLevel, JspWriter out) throws NamingException, IOException {
	   try{
        for (NamingEnumeration names = context.listBindings(name); names.hasMore();) {
            Binding binding = (Binding) names.next();
            printBinding(binding, indentLevel, out);
            Object obj = binding.getObject();
            if (obj instanceof Context) {
                printNode((Context) obj, "", indentLevel + 1, out);
            }
        }
	   }
        catch(NameNotFoundException e) {
        	
        }
    }
    
    
   /* Prints a basic representation of the given binding. Using StringBuffer
    * instead of StringBuilder here as we're targeting the lowest common
    * denominator in J2SE 1.4 installations.
    */

    void printBinding(Binding binding, int indentLevel, JspWriter out) throws IOException {
        StringBuffer buffer = new StringBuffer();
        buffer.append(padding(indentLevel)).append("+ '");
        buffer.append(binding.getName()).append("' is a ");
        buffer.append(binding.getClassName()).append("<br/>");
        out.print(buffer.toString());
    }
    
    
   /* Returns a string that will be used for padding/indenting any bindings
    * we will render. We can't really rely on JavaSE 5 String.format() here as
    * this must also work for 1.4 installations (yes, there's still plenty of
    * them around).
    */
    
    String padding(int indentLevel) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < indentLevel; i++) {
            buffer.append(INDENT);
        }
        return buffer.toString();
    }
   
    Object printValue(Context context, String name, JspWriter out) {
    	try{
    	   return context.lookup(name);
    	}
    	catch(Exception e) {
    		return null;
    	}
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JNDI Contents</title>
    </head>
    <body>
        <h3>JNDI Contents</h3>
        <pre>
[empty]
<%printNode(new InitialContext(), "", 0, out);%>
        </pre>
        <pre>
[java:global]
<%printNode(new InitialContext(), "java:global", 0, out);%>
        </pre>
        <pre>
[java:]
<%printNode(new InitialContext(), "java:", 0, out);%>
        </pre>
        <pre>
[java:jdbc]
<%printNode(new InitialContext(), "java:jdbc", 0, out);%>
        </pre>
        <pre>
[java:mongo]
<%printNode(new InitialContext(), "java:mongo", 0, out);%>
        </pre>
        <pre>
[java:comp/env]
<%printNode(new InitialContext(), "java:comp/env", 0, out);%>
        </pre>
    </body>
</html>