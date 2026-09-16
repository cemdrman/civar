// One-off dev script: seeds real Istanbul places (spread across many
// districts) and 5000 posts distributed across them into civar-dev, so the
// map/feed have real, geographically-realistic density to browse for QA.
//
// Uses the same public REST APIs a real client SDK uses, authenticated as
// the 3 test users created by seed_test_data.mjs — every write is subject
// to the same firestore.rules as the app itself.
//
// Usage:
//   node scripts/seed_istanbul_posts.mjs
//   node scripts/seed_istanbul_posts.mjs --emulator

const PROJECT_ID = 'civar-dev';
const API_KEY = 'AIzaSyB2iMTRZeqH_Jm0xEzEKBsqo3UvxuSuys0';
const USE_EMULATOR = process.argv.includes('--emulator');
const countArg = process.argv.find((a) => a.startsWith('--count='));
const TOTAL_POSTS = countArg ? Number(countArg.split('=')[1]) : 5000;
const CONCURRENCY = 25;

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

// [district, name, category, lat, lng]
const PLACES = [
  ['Kadıköy', 'Moda Sahili', 'Sahil', 40.9789, 29.0261],
  ['Kadıköy', 'Kadıköy Çarşı Kahvesi', 'Kafe', 40.9908, 29.0269],
  ['Kadıköy', 'Bahariye Caddesi', 'Sokak', 40.9877, 29.0301],
  ['Beşiktaş', 'Beşiktaş Meydan', 'Meydan', 41.0422, 29.0083],
  ['Beşiktaş', 'Ortaköy Sahili', 'Sahil', 41.0473, 29.0272],
  ['Beşiktaş', 'Barbaros Bulvarı', 'Cadde', 41.0453, 29.0089],
  ['Üsküdar', 'Salacak Sahili', 'Sahil', 41.0177, 29.0043],
  ['Üsküdar', 'Üsküdar Meydan', 'Meydan', 41.0264, 29.0152],
  ['Üsküdar', 'Çamlıca Tepesi', 'Park', 41.0289, 29.0672],
  ['Şişli', 'Nişantaşı Kahve', 'Kafe', 41.0476, 28.9942],
  ['Şişli', 'Harbiye Parkı', 'Park', 41.0512, 28.9897],
  ['Şişli', 'Cevahir Meydanı', 'AVM', 41.0632, 28.9887],
  ['Beyoğlu', 'İstiklal Caddesi', 'Cadde', 41.0345, 28.9779],
  ['Beyoğlu', 'Galata Kulesi', 'Tarihi', 41.0256, 28.9744],
  ['Beyoğlu', 'Karaköy Sahili', 'Sahil', 41.0233, 28.9738],
  ['Bakırköy', 'Bakırköy Sahili', 'Sahil', 40.9718, 28.8721],
  ['Bakırköy', 'Ataköy Marina', 'Marina', 40.9791, 28.8511],
  ['Bakırköy', 'Bakırköy Meydan', 'Meydan', 40.9819, 28.8772],
  ['Sarıyer', 'Emirgan Korusu', 'Park', 41.1078, 29.0533],
  ['Sarıyer', 'Sarıyer Sahili', 'Sahil', 41.1667, 29.0500],
  ['Sarıyer', 'Rumeli Kavağı', 'Sahil', 41.1917, 29.0619],
  ['Maltepe', 'Maltepe Sahili', 'Sahil', 40.9351, 29.1306],
  ['Maltepe', 'Maltepe Meydan', 'Meydan', 40.9357, 29.1512],
  ['Maltepe', 'Maltepe Parkı', 'Park', 40.9280, 29.1367],
  ['Ataşehir', 'Ataşehir Meydanı', 'Meydan', 40.9923, 29.1244],
  ['Ataşehir', 'Ataşehir AVM', 'AVM', 40.9838, 29.1275],
  ['Ataşehir', 'Ataşehir Parkı', 'Park', 40.9861, 29.1198],
  ['Fatih', 'Sultanahmet Meydanı', 'Tarihi', 41.0058, 28.9769],
  ['Fatih', 'Eminönü Sahili', 'Sahil', 41.0175, 28.9706],
  ['Fatih', 'Fatih Camii Meydanı', 'Meydan', 41.0192, 28.9497],
  ['Beylikdüzü', 'Beylikdüzü Sahili', 'Sahil', 40.9789, 28.6408],
  ['Beylikdüzü', 'Marmara Park AVM', 'AVM', 41.0019, 28.6547],
  ['Beylikdüzü', 'Beylikdüzü Meydan', 'Meydan', 41.0044, 28.6425],
  ['Kartal', 'Kartal Sahili', 'Sahil', 40.9061, 29.1899],
  ['Kartal', 'Kartal Meydan', 'Meydan', 40.9033, 29.1839],
  ['Kartal', 'Yakacık Korusu', 'Park', 40.8814, 29.2072],
];

const TEMPLATES = [
  (n, c) => `${n} bugün de çok kalabalıktı ama değdi.`,
  (n, c) => `${n}'de akşam saatleri gerçekten güzel.`,
  (n, c) => `Buraya ilk kez geldim, ${n} beklediğimden iyiydi.`,
  (n, c) => `${n} civarında park yeri bulmak biraz zor.`,
  (n, c) => `${c} arayanlara ${n}'yi öneririm.`,
  (n, c) => `${n}'de az önce güzel bir canlı müzik vardı.`,
  (n, c) => `Sabah erken saatte ${n} çok sakin oluyor.`,
  (n, c) => `${n} manzarası fotoğraf çekmek için harika.`,
  (n, c) => `${n}'de fiyatlar biraz arttı ama hâlâ gidilir.`,
  (n, c) => `Hafta sonu ${n}'ye uğradım, tavsiye ederim.`,
  (n, c) => `${n} çevresinde yeni bir yer açılmış, denedim.`,
  (n, c) => `${n}'de köpeğimle yürüyüş yaptım, çok keyifliydi.`,
  (n, c) => `Bugün ${n}'de arkadaşlarla buluştuk, güzel vakit geçirdik.`,
  (n, c) => `${n} akşamları biraz karanlık kalıyor, dikkatli olun.`,
  (n, c) => `${n}'nin burada olduğunu yeni fark ettim, süper bir yer.`,
];

function randomText(placeName, category) {
  const template = TEMPLATES[Math.floor(Math.random() * TEMPLATES.length)];
  return template(placeName, category);
}

function randomPastDate() {
  const daysAgo = Math.random() * 45;
  return new Date(Date.now() - daysAgo * 86400000);
}

// Standard geohash (base32, longitude-first at even bit steps), precision 9 —
// matches geoflutterfire_plus's GeoFirePoint.geohash exactly (see
// geoflutterfire_plus/lib/src/math.dart's encode()).
const BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';
function geohashEncode(lat, lng, precision = 9) {
  let latMin = -90, latMax = 90, lngMin = -180, lngMax = 180;
  let isEven = true;
  let bit = 0, ch = 0;
  let hash = '';
  while (hash.length < precision) {
    if (isEven) {
      const mid = (lngMin + lngMax) / 2;
      if (lng > mid) { ch = (ch << 1) + 1; lngMin = mid; } else { ch = (ch << 1) + 0; lngMax = mid; }
    } else {
      const mid = (latMin + latMax) / 2;
      if (lat > mid) { ch = (ch << 1) + 1; latMin = mid; } else { ch = (ch << 1) + 0; latMax = mid; }
    }
    isEven = !isEven;
    if (++bit === 5) {
      hash += BASE32[ch];
      bit = 0;
      ch = 0;
    }
  }
  return hash;
}

function str(value) {
  return { stringValue: value };
}

async function signIn(user) {
  const res = await fetch(`${AUTH_BASE}/accounts:signInWithPassword?key=${API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: user.email, password: user.password, returnSecureToken: true }),
  });
  const data = await res.json();
  if (!data.idToken) throw new Error(`Sign-in failed for ${user.email}: ${JSON.stringify(data)}`);
  return { ...user, idToken: data.idToken, uid: data.localId };
}

async function firestoreRequest(path, idToken, method, body) {
  const res = await fetch(`${FIRESTORE_BASE}${path}`, {
    method,
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${idToken}` },
    body: body ? JSON.stringify(body) : undefined,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(`${method} ${path} failed: ${JSON.stringify(data)}`);
  return data;
}

async function seedPlaces(authorAuth) {
  console.log(`Seeding ${PLACES.length} places across ${new Set(PLACES.map((p) => p[0])).size} Istanbul districts...`);
  const ids = [];
  for (const [district, name, category, lat, lng] of PLACES) {
    const docId = `ist_${district}_${name}`.toLowerCase().replace(/[^a-z0-9ığüşöç]+/gi, '_');
    await firestoreRequest(`/places/${docId}`, authorAuth.idToken, 'PATCH', {
      fields: {
        name: str(name),
        category: str(category),
        lat: { doubleValue: lat },
        lng: { doubleValue: lng },
        mapAnchorX: { doubleValue: 0.5 },
        mapAnchorY: { doubleValue: 0.5 },
        heat: { doubleValue: Math.random() * 0.5 + 0.1 },
        district: str(district),
      },
    });
    ids.push({ id: docId, name, category, lat, lng });
  }
  return ids;
}

async function createPost(author, place) {
  const createdAt = randomPastDate();
  const geohash = geohashEncode(place.lat, place.lng);
  await firestoreRequest('/posts', author.idToken, 'POST', {
    fields: {
      placeId: str(place.id),
      authorId: str(author.uid),
      authorName: str(author.fullName),
      authorInitials: str(author.initials),
      text: str(randomText(place.name, place.category)),
      hasMedia: { booleanValue: false },
      likeCount: { integerValue: String(Math.floor(Math.random() * 40)) },
      createdAt: { timestampValue: createdAt.toISOString() },
      geo: {
        mapValue: {
          fields: {
            geopoint: { geoPointValue: { latitude: place.lat, longitude: place.lng } },
            geohash: str(geohash),
          },
        },
      },
    },
  });
}

async function runPool(items, worker, concurrency) {
  let index = 0;
  let done = 0;
  async function next() {
    while (index < items.length) {
      const i = index++;
      await worker(items[i], i);
      done++;
      if (done % 250 === 0) console.log(`  ${done}/${items.length} posts written`);
    }
  }
  await Promise.all(Array.from({ length: concurrency }, next));
}

async function main() {
  console.log(`Signing in test users against ${USE_EMULATOR ? 'the local emulator' : PROJECT_ID} ...`);
  const authors = await Promise.all(TEST_USERS.map(signIn));

  const places = await seedPlaces(authors[0]);

  console.log(`Writing ${TOTAL_POSTS} posts across ${places.length} places (concurrency ${CONCURRENCY})...`);
  const jobs = Array.from({ length: TOTAL_POSTS }, (_, i) => ({
    author: authors[i % authors.length],
    place: places[Math.floor(Math.random() * places.length)],
  }));
  await runPool(jobs, (job) => createPost(job.author, job.place), CONCURRENCY);

  console.log(`\nDone. Seeded ${places.length} places and ${TOTAL_POSTS} posts across Istanbul.`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
