const fetch = require('node-fetch'); // You might need to install node-fetch if using Node < 18 or just use native fetch in Node 18+

const BASE_URL = 'http://localhost:3000/api/auth';

async function testAuth() {
    console.log('--- Testing Authentication ---');

    const testUser = {
        email: `test${Date.now()}@example.com`,
        password: 'password123',
        name: 'Test User'
    };

    try {
        // 1. Register
        console.log('\n1. Testing Register...');
        const registerRes = await fetch(`${BASE_URL}/register`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testUser)
        });
        const registerData = await registerRes.json();
        console.log('Status:', registerRes.status);
        console.log('Response:', registerData);

        if (registerRes.status !== 201) {
            console.error('Register failed!');
            return;
        }

        // 2. Login
        console.log('\n2. Testing Login...');
        const loginRes = await fetch(`${BASE_URL}/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                email: testUser.email,
                password: testUser.password
            })
        });
        const loginData = await loginRes.json();
        console.log('Status:', loginRes.status);
        console.log('Response:', loginData);

        if (loginRes.status === 200 && loginData.token) {
            console.log('\nSUCCESS: Authentication flow works!');
        } else {
            console.error('\nFAIL: Login failed or no token received.');
        }

    } catch (error) {
        console.error('Test error:', error);
    }
}

// Check node version for fetch support otherwise warn
if (Number(process.versions.node.split('.')[0]) < 18) {
    console.log("Warning: Node 18+ required for native fetch. If using older node, install node-fetch.");
}

testAuth();
