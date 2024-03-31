package room;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import cartago.Artifact;

/**
 * A CArtAgO artifact that provides an operation for sending messages to agents 
 * with KQML performatives using the dweet.io API
 */
public class DweetArtifact extends Artifact {
    String thing = "message";
    HttpClient client = HttpClient.newHttpClient();

    void dweet() {
        try {
            URI uri = new URI("https", "dweet.io", "/dweet/for/" + thing, null, null);

            String data = "{\"content\":\"Hello Friend\"}";

            HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(data))
                .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                System.out.println("Dweet sent successfully.");
            } else {
                System.out.println("Failed to send dweet. Status code: " + response.statusCode());
            }
        } catch (Exception e) {
            System.out.println("Error while sending dweet: " + e.getMessage());
        }
    }
}
