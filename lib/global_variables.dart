import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase instance
final supabase = Supabase.instance.client;

// IpAddress to connect with API
const String ipAddress = "http://172.30.1.199:8080";

// User logged variables
String loggedUserEmail = "";
String loggedUserName = "";
int loggedUserId = 0;


//user: alejandroarcasleon@gmail.com