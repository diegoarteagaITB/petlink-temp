import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase instance
final supabase = Supabase.instance.client;

// IpAddress to connect with API
const String ipAddress = "http://192.168.1.134:8080";

// User logged variables
String loggedUserEmail = "";
String loggedUserName = "";
int loggedUserId = 0;


//user: alejandroarcasleon@gmail.com