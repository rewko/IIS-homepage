<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import namespace="Microsoft.Web.Administration" %>
<%@ Import namespace="System.Linq" %>
<script runat="server" type="text/C#">
    public SiteCollection Sites { get; private set; }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Sites = new ServerManager().Sites;
    }

</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=Server.MachineName.ToLower() %></title>
    <style type="text/css">
        #index li a.application {
            font-weight: bold;
            text-decoration: none;
        }

        #index li a.directory {
            text-decoration: none;
        }

        #index li > .path {
            font-style: italic;
            color: lightgrey;
        }

        #index li:hover > .path {
            font-style: italic;
            color: grey;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="index">
        <% foreach (var site in Sites) { %>
             <h1><%=site.Name %></h1>   
             <ul>
             <% foreach (var app in site.Applications) { %>
                <% string root = string.Format("{0}://{1}:{2}/{3}", site.Bindings[0].Protocol, HttpContext.Current.Request.Url.Host, site.Bindings[0].EndPoint.Port, app.Path.TrimStart('/')); %>
                <li>
                    <% if (app.VirtualDirectories.Count == 1) { %>
                        <a href="<%= root %>" class="application"><%= app.Path == "/" ? Server.MachineName.ToLower() : app.Path.TrimStart('/') %></a>&nbsp;<span class="path">(<%=app.VirtualDirectories[0].PhysicalPath %>)</span>
                    <% } else { %>
                        <a href="<%= root %>" class="directory"><%= app.Path == "/" ? Server.MachineName.ToLower() : app.Path.TrimStart('/') %></a>&nbsp;<span class="path">(<%=app.VirtualDirectories[0].PhysicalPath %>)</span>
                        <ul>
                        <% foreach (var virtDir in app.VirtualDirectories) { %>
                            <% if (virtDir.Path == "/") continue; %>
                            <li><a href="<%= root + virtDir.Path.TrimStart('/') %>" class="directory"><%= virtDir.Path.TrimStart('/') %></a>&nbsp;<span class="path">(<%=virtDir.PhysicalPath %>)</span></li>
                        <% } %>
                        </ul>
                    <% } %>
                </li>
            <% } %>
            </ul>
        <% } %>
        </div>
    </form>
</body>
</html>
