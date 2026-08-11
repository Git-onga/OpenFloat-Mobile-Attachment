# Firestore Setup for Home Page Data

## Collection Structure

Create the following Firestore structure:

```
users (collection)
  └── {userId} (document)
      └── home_items (subcollection)
          ├── {itemId} (document)
          │   ├── id: string
          │   ├── title: string
          │   ├── description: string
          │   ├── created_at: timestamp
          │   ├── job_id: string (optional)
          │   ├── job_status: string (optional)
          │   ├── elapsed_time: string (optional)
          │   ├── worker_name: string (optional)
          │   ├── worker_profession: string (optional)
          │   ├── worker_rating: number (optional)
          │   ├── worker_image_url: string (optional)
          │   ├── job_details: string (optional)
          │   ├── hourly_rate: string (optional)
          │   ├── category: string (optional) - "ongoing" or "booking"
          │   └── image_url: string (optional)
          └── {itemId} (document)
              └── ... same structure
```

## Security Rules

Add these rules to your Firestore security rules to allow read/write:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own home_items
    match /users/{userId}/home_items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Sample Data

Here's a sample document to add to your Firestore:

```json
{
  "id": "JOB-2024-001",
  "title": "Plumbing Repair",
  "description": "Burst pipe under kitchen sink. Water leaking onto floor.",
  "created_at": "2024-08-03T10:00:00.000Z",
  "job_id": "JOB-2024-001",
  "job_status": "In Progress",
  "elapsed_time": "02:12:24",
  "worker_name": "Muriuki James",
  "worker_profession": "Plumber",
  "worker_rating": 4,
  "job_details": "Fix burst pipe under kitchen sink...",
  "hourly_rate": "KES 100/=",
  "category": "ongoing"
}
```

## How It Works

1. When the home page loads, `HomeBloc` triggers `HomeDataRequested`
2. `HomeRepositoryImpl` calls `HomeFirebaseDataSource.getHomeItemsForUser()`
3. The data source reads from `users/{userId}/home_items` subcollection
4. If Firebase fails or returns empty, it falls back to the API
5. If both fail, mock data is displayed for demo/offline mode

## Testing

To test the Firebase integration:

1. Add sample data to your Firestore collection
2. Run `flutter run`
3. Log in with a user
4. The home page should display the data from Firestore

## Error Handling

- If Firebase is unreachable: Falls back to API
- If API is unreachable: Shows mock data
- If both fail: Shows error message and retry button
