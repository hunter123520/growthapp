import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FeedbackComponent extends StatefulWidget {
  @override
  _FeedbackComponentState createState() => _FeedbackComponentState();
}

class _FeedbackComponentState extends State<FeedbackComponent> {
  bool liked = false;
  bool disliked = false;
  TextEditingController remarksController = TextEditingController();

  void toggleLike() {
    setState(() {
      liked = !liked;
      disliked = false; // If liked, set disliked to false
    });
  }

  void toggleDislike() {
    setState(() {
      disliked = !disliked;
      liked = false; // If disliked, set liked to false
    });
  }

  void submitFeedback() {
    // Collect the feedback information here
    String feedback = liked ? 'Liked' : disliked ? 'Disliked' : 'No preference';
    String remarks = remarksController.text.isNotEmpty ? remarksController.text : 'No remarks';
    
    // Print or send feedback to backend or any desired destination
    print('Feedback: $feedback');
    print('Remarks: $remarks');
    
    // Optionally, you can clear the input fields after submission
    remarksController.clear();
    setState(() {
      liked = false;
      disliked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Did you like the answer?"
          Text('Did you like the answer?'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Like and Dislike buttons
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up, color: liked ? Colors.green : Colors.grey),
                onPressed: toggleLike,
              ),
              IconButton(
                icon: Icon(Icons.thumb_down, color: disliked ? Colors.red : Colors.grey),
                onPressed: toggleDislike,
              ),
            ],
          ),

          // "Do you want to see tips?"
          SizedBox(height: 16),
          Text('Would you like to view tips?'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle viewing tips logic here
                  print('Showing tips');
                },
                child: Text('View Tips'.tr()),
              ),
            ],
          ),
          
          // Remarks Text Field
          SizedBox(height: 16),
          Text('Any remarks or suggestions?'.tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            controller: remarksController,
            decoration: InputDecoration(
              hintText: 'Enter your remarks here...'.tr(),
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),

          // Submit Button
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: submitFeedback,
              child: Text('Submit Feedback'.tr()),
              style: ElevatedButton.styleFrom(
    backgroundColor: Colors.teal, // Sleek and modern color
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Less rounded for formality
    ),
    elevation: 1, // Minimal shadow for a flat design
  ),
            ),
            
          ),
        ],
      ),
    );
  }
}
