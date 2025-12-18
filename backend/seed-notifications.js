const fetch = require('node-fetch');

async function seed() {
    try {
        // Requires authentication, so we need to login first or just use a direct DB call if running locally.
        // For simplicity, let's assume this script is for dev usage and we might need to login.
        // However, the backend endpoint for seeding notification requires auth middleware? 
        // Let's check routes. properties: router.post('/seed', authMiddleware, ...);
        // Yes it does. 

        // To make it easier for user, let's create a public seed endpoint for dev or just use curl with token.
        // Or improved approach: create a separate seed-all script that doesn't need auth (testing purpose).

        console.log("To seed notifications, please use Postman or Curl after logging in, because it requires a specific User ID.");
        console.log("Endpoint: POST http://localhost:3000/api/notifications/seed");
        console.log("Headers: Authorization: Bearer <TOKEN>");

    } catch (error) {
        console.error('Error:', error);
    }
}

seed();
