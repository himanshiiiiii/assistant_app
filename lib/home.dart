import 'package:assistant_app/colors.dart';
import 'package:assistant_app/features.dart';
import 'package:assistant_app/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final speechToText=SpeechToText();
final flutterTts = FlutterTts();
  String lastwords='';
  final OpenAIService openAIService=OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTexttoSpeech();
  }

 Future<void> initTexttoSpeech() async{
   await flutterTts.setSharedInstance(true);
   setState(() {});
 }
  Future<void> initSpeechToText() async{
await speechToText.initialize();
setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

 void onSpeechResult(SpeechRecognitionResult result) {
   setState(() {
     lastwords = result.recognizedWords;
   });
 }

 Future<void>sytemSpeak(String content) async{
    await flutterTts.speak(content);
 }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Assistant",style: GoogleFonts.aBeeZee(fontSize: 25,fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: Icon(Icons.menu),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SizedBox(height: size.height*0.01,),
          Stack(children: [
            Center(
              child: Container(
                height: size.height*0.18,
                width: size.width*0.8,
                margin: EdgeInsets.only(top: 4),

                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallete.assistantCircleColor,
                ),
              ),
            ),
            Center(child:Image(image: AssetImage("assets/images/virtualAssistant.png"),

              height: size.height*0.185,
              width: size.width*0.5,
            ))]),

SizedBox(height: size.height*0.05,),
          //chat container
          Visibility(
            visible: generatedImageUrl==null,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                border: Border.all(color: Pallete.borderColor)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:  Text(
                  (generatedContent == null)?"Good Morning ! What task can I do for you?": generatedContent!,
                  style: GoogleFonts.poppins(
                  fontSize: (generatedContent==null)?18:15,color: Pallete.mainFontColor,
                  height: 1.5,
                  fontWeight: FontWeight.w500
                ),),
              ),
            ),
          ),

if(generatedImageUrl !=null) Padding(
  padding: const EdgeInsets.all(10.0),
  child:  ClipRRect(borderRadius: BorderRadius.circular(20),
      child: Image.network(generatedImageUrl!)),
),
//choice list
          Visibility(
            visible: generatedContent==null && generatedImageUrl==null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
              child: Text("Choose one of them",style: GoogleFonts.poppins(
                  fontSize: 20,color: Pallete.mainFontColor,
                  fontWeight: FontWeight.w700,
              ),),
            ),
          ),

Visibility(
  visible: generatedContent==null && generatedImageUrl==null,
  child:   Column(
  
    children:const [
  
      FeatureWidget(color: Pallete.firstSuggestionBoxColor,
  
        heading: "ChatGPT",
  
        content: "A breakthrough in nuanced and perceptive communication.",),
  
      FeatureWidget(color: Pallete.secondSuggestionBoxColor,
  
        heading: "Dall -E",
  
        content: "A smart AI translating text into captivating visuals with precision and creativity.",),
  
      FeatureWidget(color: Pallete.thirdSuggestionBoxColor,
  
        heading: "Smart Voice Assistant",
  
        content: "A conversational companion, providing sharp and concise answers.",)
  
    ],
  
  ),
)
        ],

      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
              print(lastwords);
            } else if (speechToText.isListening) {
             final speech =await openAIService.isArtPrompt(lastwords);
             if(speech.contains('https')){
generatedImageUrl=speech;
generatedContent=null;
//set state called as we have to display content on screen means make change
setState(() {});
             }else
               {
                 generatedImageUrl=null;
                 generatedContent=speech;
                 setState(() {});
                 await sytemSpeak(speech);
                 //set state called as we have to display content on screen means make change

               }
             print(speech);
              await stopListening();

            }
            else {
             initSpeechToText();
            }
        },
        child: Icon((speechToText.isListening)?Icons.stop:Icons.mic,color: Colors.black,),
      backgroundColor: Pallete.firstSuggestionBoxColor.withOpacity(0.9),
      ) ,
    );
  }
}
