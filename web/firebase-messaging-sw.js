importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAeliEuUDxVV3-nkO-Ell9fFcifr9jtQtU",
  authDomain: "pede-logo-99040.firebaseapp.com",
  projectId: "pede-logo-99040",
  storageBucket: "pede-logo-99040.appspot.com",
  messagingSenderId: "1025418518982",
  appId: "1:1025418518982:web:6b3344421699a0bfa752c7",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});