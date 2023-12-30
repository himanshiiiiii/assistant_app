import 'dart:convert';

import 'package:assistant_app/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService{

  //list to store all the past messages and to give smarter reply
  final List<Map<String,String>> messages=[];

  //this function is to decide wheter a user wants an image or not.Decideable API
  Future<String> isArtPrompt(String prompt)async{
try{
 final res= await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
 headers: {
   'Content-Type': 'application/json',
   'Authorization': 'Bearer $OPENAIapiKey',
 },
 body: jsonEncode({
     "model": "gpt-3.5-turbo",
     "messages": [
     {
     'role':'user',
     'content':'Does this message want to generate AI picture,image,art or anything similar? $prompt . Simply answer with a yes or no.',
     },
     ],
     }),
 );
print(res.statusCode);
print(res.body);

if(res.statusCode == 200)
  {

    String content = jsonDecode(res.body)['choices'][0]['message']['content'];
    content =content.trim();

    switch(content){
      case 'Yes':
      case 'yes':
      case 'Yes.':
      case 'yes.':
       final res= await DallEAPI(prompt);
       return res;
      default:
        final res=await chatGPT(prompt);
        return res;
    }
  }
return 'An Internal error occurred';
}
    catch(e){
  return e.toString();
    }
  }


  //this comes into use when user does not want image
  Future<String> chatGPT(String prompt)async{

    //this is what i said ad passed the prompt
messages.add({
  'role':'user',
  'content':prompt,
});
    try{
      final res= await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAIapiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );
      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200)
      {

        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content =content.trim();

//this is what assistant has said as gpt remembers the conversations
// and based on that gives more appropriate answers
        messages.add({
          'role':'assistant',
          'content':content,
        });
        return content;
      }
      return 'An Internal error occurred';
    }
    catch(e){
      return e.toString();
    }

  }
  Future<String> DallEAPI(String prompt)async{
    //this is what i said ad passed the prompt
    messages.add({
      'role':'user',
      'content':prompt,
    });
    try{
      final res= await http.post(Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAIapiKey',
        },
        body: jsonEncode({
         'prompt':prompt,
          'n':1
        }),
      );
      print(res.statusCode);
      print(res.body);

      if(res.statusCode == 200)
      {

        String imageurl = jsonDecode(res.body)['data'][0]['url'];
        imageurl =imageurl.trim();

//this is what assistant has said as gpt remembers the conversations
// and based on that gives more appropriate answers
        messages.add({
          'role':'assistant',
          'content':imageurl,
        });
        return imageurl;
      }
      return 'An Internal error occurred';
    }
    catch(e){
      return e.toString();
    }
  }
}