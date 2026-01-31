import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Twilio Service for triggering emergency phone calls
class TwilioService {
  TwilioService._();
  static final instance = TwilioService._();

  // Fetch credentials from environmental variables
  static String get _accountSid => dotenv.env['TWILIO_ACCOUNT_SID'] ?? '';
  static String get _authToken => dotenv.env['TWILIO_AUTH_TOKEN'] ?? '';
  static String get _fromNumber => dotenv.env['TWILIO_FROM_NUMBER'] ?? '';
  static String get _toNumber => dotenv.env['TWILIO_TO_NUMBER'] ?? '';
  
  /// TwiML message for the emergency call
  static String _getTwiML(String applianceName) {
    return '''
      <Response>
        <Say voice="alice">
          Alert! This is an emergency call from the WI4ED electrical safety system.
          An anomaly has been detected with your $applianceName.
          Please check the appliance immediately or contact a professional.
        </Say>
        <Pause length="1"/>
        <Say voice="alice">
          Repeating: $applianceName requires immediate attention.
        </Say>
      </Response>
    ''';
  }

  /// Trigger an emergency call via Twilio
  /// Returns true if the call was initiated successfully
  Future<bool> triggerEmergencyCall({
    required String applianceName,
    String? customToNumber,
  }) async {
    final toNumber = customToNumber ?? _toNumber;
    
    // Twilio API endpoint
    final url = Uri.parse(
      'https://api.twilio.com/2010-04-01/Accounts/$_accountSid/Calls.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_accountSid:$_authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'To': toNumber,
          'From': _fromNumber,
          'Twiml': _getTwiML(applianceName),
        },
      );

      if (response.statusCode == 201) {
        // Call initiated successfully
        print('📞 Emergency call initiated for $applianceName');
        return true;
      } else {
        print('❌ Twilio API error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Failed to trigger call: $e');
      return false;
    }
  }

  /// Check if credentials are configured
  bool get isConfigured {
    return _accountSid.isNotEmpty && _authToken.isNotEmpty;
  }
}
