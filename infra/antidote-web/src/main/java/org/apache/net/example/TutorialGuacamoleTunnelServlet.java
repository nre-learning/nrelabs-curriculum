package org.apache.guacamole.net.example;

import java.util.logging.Logger;
import java.util.Enumeration;
import java.io.BufferedReader;

import javax.servlet.http.HttpServletRequest;
import org.apache.guacamole.GuacamoleException;
import org.apache.guacamole.net.GuacamoleSocket;
import org.apache.guacamole.net.GuacamoleTunnel;
import org.apache.guacamole.net.InetGuacamoleSocket;
import org.apache.guacamole.net.SimpleGuacamoleTunnel;
import org.apache.guacamole.protocol.ConfiguredGuacamoleSocket;
import org.apache.guacamole.protocol.GuacamoleConfiguration;
import org.apache.guacamole.servlet.GuacamoleHTTPTunnelServlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


class Lab {
    public int LabUUID;
    public int labId;
    public Endpoint[] endpoints = new Endpoint[]{};
    public boolean ready;
}

class Endpoint {
    public String name;
    public String type;
    public String port;
}

public class TutorialGuacamoleTunnelServlet
    extends GuacamoleHTTPTunnelServlet {

    @Override
    protected GuacamoleTunnel doConnect(HttpServletRequest request)
        throws GuacamoleException {

        Logger log = Logger.getLogger("com.antidote.servlet");

        // Map<String, GuacamoleConfiguration> configs = new  Map<String, GuacamoleConfiguration>;
        // https://github.com/glyptodon/guacamole-client/blob/master/guacamole/src/main/java/org/apache/guacamole/tunnel/websocket/tomcat/RestrictedGuacamoleWebSocketTunnelServlet.java

        String query = request.getQueryString();

        // Useful for tracking session
        // request.getCookies();

        // Get referer - useful to derive lab ID
        Enumeration<String> headerNames = request.getHeaderNames();
        String referer = "";
        if (headerNames != null) {
                while (headerNames.hasMoreElements()) {
                        String ne = headerNames.nextElement();
                        if (ne == "referer") {
                            referer = request.getHeader(ne);
                            log.info("Detected referer: " + referer);
                        }
                }
        }


        // Get device name from body
        String deviceName = "";
        try {
            BufferedReader reader = request.getReader();
            deviceName = reader.readLine();
            reader.close();
        } catch (IOException e) {
            log.info("Problem getting device name " + e.getMessage());
        }

        log.info("Connecting to Syringe API");

        Lab thisLab = new Lab();
        try {
            HttpClient client = new DefaultHttpClient();
            // TODO Should use internal Service DNS instead of this so you have redundancy
            // TODO also need to get lab ID dynamically from the referer probably
            HttpGet restreq = new HttpGet("http://tf-controller0:30010/exp/lab/1");
            HttpResponse response = client.execute(restreq);
            BufferedReader rd = new BufferedReader (new InputStreamReader(response.getEntity().getContent()));
            String restline = "";
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            while ((restline = rd.readLine()) != null) {
                thisLab = gson.fromJson(restline, Lab.class);
            }
        }
        catch (IOException e) {
            log.info("Problem connecting to Syringe API");
        }

        log.info("Configuring Guacamole tunnel");

        // Create our configuration
        GuacamoleConfiguration device = new GuacamoleConfiguration();

        for (int i = 0; i < thisLab.endpoints.length; i++){
            if (thisLab.endpoints[i].name.equals(deviceName)) {
                log.info("Configuring new guacamole configuration for " + thisLab.endpoints[i].name);
                device.setProtocol("ssh");
                device.setParameter("hostname", "vip.labs.networkreliability.engineering");
                device.setParameter("port", thisLab.endpoints[i].port.toString());
                device.setParameter("password", "Password1!");
                break;
            }
        }

        // Connect to guacd - everything is hard-coded here.
        GuacamoleSocket socket = new ConfiguredGuacamoleSocket(
                new InetGuacamoleSocket("localhost", 4822),
                device
        );

        GuacamoleTunnel tunnel = new SimpleGuacamoleTunnel(socket);
        return tunnel;

    }
}
