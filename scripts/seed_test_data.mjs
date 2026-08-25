// One-off dev script: seeds a handful of real test accounts, DM threads, and
// messages into the civar-dev Firebase project (or the local emulator).
//
// Deliberately uses the same public REST APIs a real client SDK uses (Identity
// Toolkit for sign-up, Firestore REST for document writes) — each write is
// made as the relevant test user's own ID token, so it's subject to the same
// firestore.rules as the app itself. No admin/service-account credentials.
//
// Usage:
//   node scripts/seed_test_data.mjs                 # against civar-dev (cloud)
//   node scripts/seed_test_data.mjs --emulator       # against the local emulator suite
//
// Run `firebase emulators:start` first if using --emulator.

const PROJECT_ID = 'civar-dev';
const API_KEY = 'AIzaSyB2iMTRZeqH_Jm0xEzEKBsqo3UvxuSuys0'; // web app key (public, client-safe)
const USE_EMULATOR = process.argv.includes('--emulator');

const AUTH_BASE = USE_EMULATOR
  ? 'http://127.0.0.1:9099/identitytoolkit.googleapis.com/v1'
  : 'https://identitytoolkit.googleapis.com/v1';
const FIRESTORE_BASE = USE_EMULATOR
  ? `http://127.0.0.1:8080/v1/projects/${PROJECT_ID}/databases/(default)/documents`
  : `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents`;

const TEST_USERS = [
  { email: 'ayse.test@civar.dev', password: 'test1234', fullName: 'Ayşe Kaya', initials: 'AK' },
  { email: 'mert.test@civar.dev', password: 'test1234', fullName: 'Mert Demir', initials: 'MD' },
  { email: 'elif.test@civar.dev', password: 'test1234', fullName: 'Elif Şahin', initials: 'ES' },
];

async function signUpOrSignIn(user) {
  const signUpRes = await fetch(`${AUTH_BASE}/accounts:signUp?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: user.email, password: user.password, returnSecureToken: true }),
  });
  const signUpData = await signUpRes.json();
  if (signUpData.idToken) {
    console.log(`  created ${user.email}`);
    return { idToken: signUpData.idToken, uid: signUpData.localId };
  }

  // Already exists from a previous run — sign in instead.
  const signInRes = await fetch(`${AUTH_BASE}/accounts:signInWithPassword?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: user.email, password: user.password, returnSecureToken: true }),
  });
  const signInData = await signInRes.json();
  if (!signInData.idToken) {
    throw new Error(`Could not sign up or sign in ${user.email}: ${JSON.stringify(signInData)}`);
  }
  console.log(`  already existed, signed in ${user.email}`);
  return { idToken: signInData.idToken, uid: signInData.localId };
}

function str(value) {
  return { stringValue: value };
}

async function firestoreRequest(path, idToken, method, body) {
  const res = await fetch(`${FIRESTORE_BASE}${path}`, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(idToken ? { Authorization: `Bearer ${idToken}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const data = await res.json();
  if (!res.ok) {
    throw new Error(`Firestore ${method} ${path} failed: ${JSON.stringify(data)}`);
  }
  return data;
}

async function upsertUserProfile(user, auth) {
  await firestoreRequest(`/users/${auth.uid}?currentDocument.exists=false`, auth.idToken, 'PATCH', {
    fields: {
      fullName: str(user.fullName),
      email: str(user.email),
      initials: str(user.initials),
      bio: str(''),
      tierId: str('free'),
    },
  }).catch(async () => {
    // Doc already exists (from a previous run) — that's fine, leave it as is.
  });
}

async function createDmThread(userA, authA, userB) {
  const body = {
    fields: {
      participantIds: { arrayValue: { values: [str(authA.uid), str(userB.uid)] } },
      participantNames: {
        mapValue: { fields: { [authA.uid]: str(userA.fullName), [userB.uid]: str(userB.fullName) } },
      },
      participantInitials: {
        mapValue: { fields: { [authA.uid]: str(userA.initials), [userB.uid]: str(userB.initials) } },
      },
      lastMessagePreview: str(''),
      lastMessageAt: { timestampValue: new Date().toISOString() },
      readBy: { arrayValue: { values: [str(authA.uid), str(userB.uid)] } },
    },
  };
  const created = await firestoreRequest('/dmThreads', authA.idToken, 'POST', body);
  return created.name.split('/').pop(); // document id
}

async function sendMessage(threadId, senderAuth, senderName, text, otherAuth) {
  await firestoreRequest(`/dmThreads/${threadId}/messages`, senderAuth.idToken, 'POST', {
    fields: {
      senderId: str(senderAuth.uid),
      text: str(text),
      sentAt: { timestampValue: new Date().toISOString() },
    },
  });
  await firestoreRequest(`/dmThreads/${threadId}?updateMask.fieldPaths=lastMessagePreview&updateMask.fieldPaths=lastMessageAt&updateMask.fieldPaths=readBy`, senderAuth.idToken, 'PATCH', {
    fields: {
      lastMessagePreview: str(text),
      lastMessageAt: { timestampValue: new Date().toISOString() },
      readBy: { arrayValue: { values: [str(senderAuth.uid)] } },
    },
  });
}

async function main() {
  console.log(`Seeding test data into ${USE_EMULATOR ? 'the local emulator' : PROJECT_ID} ...`);

  console.log('Creating test users:');
  const withAuth = [];
  for (const user of TEST_USERS) {
    const auth = await signUpOrSignIn(user);
    await upsertUserProfile(user, auth);
    withAuth.push({ ...user, ...auth });
  }

  const [ayse, mert, elif] = withAuth;

  console.log('Creating DM thread + messages: Ayşe <-> Mert');
  const thread1 = await createDmThread(ayse, ayse, mert);
  await sendMessage(thread1, ayse, ayse.fullName, 'Selam! Yorumunu gördüm, harika bir öneri.', mert);
  await sendMessage(thread1, mert, mert.fullName, 'Teşekkürler, denediğinde haber ver 🙂', ayse);

  console.log('Creating DM thread + messages: Ayşe <-> Elif');
  const thread2 = await createDmThread(ayse, ayse, elif);
  await sendMessage(thread2, elif, elif.fullName, 'Fotoğrafı atar mısın?', ayse);

  console.log('\nDone. Test accounts (email / password):');
  for (const user of TEST_USERS) {
    console.log(`  ${user.email} / ${user.password}`);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
