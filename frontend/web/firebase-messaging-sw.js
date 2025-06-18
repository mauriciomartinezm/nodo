// web/firebase-messaging-sw.js

// Importa los scripts necesarios de Firebase
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Inicializa la app de Firebase
firebase.initializeApp({
  apiKey: "AIzaSyC0BbNuHj7LNJj5fonRp-U-PTw5TXpssB4",
  authDomain: "nodo-b1ff4.firebaseapp.com",
  projectId: "nodo-b1ff4",
  storageBucket: "nodo-b1ff4.firebasestorage.app",
  messagingSenderId: "942591259454",
  appId: "1:942591259454:web:ca2476c8052f73cfe9326f",
  measurementId: "G-DTRMXS2VGY"
});

// Inicializa el servicio de mensajería
const messaging = firebase.messaging();

// Opcional: maneja notificaciones push cuando la app está en segundo plano
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Recibido mensaje en segundo plano:', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/icon-192.png' // puedes personalizar el ícono si deseas
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
