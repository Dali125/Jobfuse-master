import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobfuse/logic/make_post.dart';
import 'package:mockito/mockito.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFlutterToast extends Mock implements Fluttertoast {}

void main() {
  group('MakePost', () {
    MockFirebaseFirestore mockFirestore;
    MockFlutterToast mockFlutterToast;
    late MakePost makePost;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockFlutterToast = MockFlutterToast();
      makePost = MakePost(
        budget: '100',
        duration: '2 weeks',
        title: 'Test Post',
        clientID: 'client123',
        description: 'This is a test post',
        experienceLevel: 'Intermediate',
        category: 'Technology',
        taskType: 'Full-Time',
      );
    });

    test('UploadPost', () async {
      // Mock the necessary dependencies
      when(mockFirestore.collection('ProjectTasks')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) => Future.value());

      // Invoke the UploadPost method
      await makePost.UploadPost();

      // Verify that the document is set with the expected data
      verify(mockDocumentReference.set({
        'Budget': '100',
        'TaskType': 'Full-Time',
        'Client_id': 'client123',
        'title': 'Test Post',
        'Description': 'This is a test post',
        'Duration': '2 weeks',
        'ExperienceLevel': 'Intermediate',
        'DocumentID': anyNamed('DocumentID'),
        'category': 'Technology',
      })).called(1);

      // Verify that the Fluttertoast.showToast method is called
      verify(mockFlutterToast.showToast(msg: 'msg')).called(1);
    });

    // Add more test cases for other scenarios
  });
}
