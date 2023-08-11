const String baseUrl = "192.168.0.187:8000";
const String wsUrl = "ws://$baseUrl/";
const Map<String, String> requestHeader = {
  "Content-Type": "application/json",
};
const String gmapApi = "AIzaSyBE7UlAGmlECI-mu_O7If-rYcC0mQ3NUtE";

Map<String, String> getAuthorizationHeaders(String authToken) {
  return {
    ...requestHeader,
    "Authorization": "Token $authToken",
  };
}
