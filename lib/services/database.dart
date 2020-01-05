import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_crew/models/coffee.dart';
import 'package:coffee_crew/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference // collection corresponds to table and document correspond to rows/tuples
  // if this collection not present than firebase will create a new one
  final CollectionReference coffeeCollection =
      Firestore.instance.collection('coffees');

  Future updateUserData(String sugars, String name, int strength) async {
    // if this document not present than firebase will create a new one with this uid
    return await coffeeCollection.document(uid).setData(
        // pass the data(key value pair) to be updated in this document liked with uid of this user
        {'sugars': sugars, 'name': name, 'strength': strength});
  }

  // convert coffee list from snapshot of documents
  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Coffee(
        name: doc.data['name'] ??
            '', // if the value is not present set to empty string
        strength:
            doc.data['strength'] ?? 0, // if the value is not present set to 0
        sugars:
            doc.data['sugars'] ?? '0', // if the value is not present set to '0'
      );
    }).toList(); // convert the coffees iterable to list
  }

// user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength']);
  }

  // get coffees stream
  Stream<List<Coffee>> get coffees {
    return coffeeCollection.snapshots().map(_coffeeListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return coffeeCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
