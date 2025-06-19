// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDHQSFuRnUszrTdmrsA8y3JebQiYfPIyPQ",
  authDomain: "qualitysystem-74ae9.firebaseapp.com",
  projectId: "qualitysystem-74ae9",
  storageBucket: "qualitysystem-74ae9.firebasestorage.app",
  messagingSenderId: "79320910267",
  appId: "1:79320910267:web:f12a962941ac8991d85c9e",
  measurementId: "G-B9SJVCR0VC"
});

const messaging = firebase.messaging();
