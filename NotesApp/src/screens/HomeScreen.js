import React, { useEffect } from "react";
import { View, Text, StyleSheet, TouchableOpacity } from "react-native";
import { useAuth } from "../contexts/AuthContext";

const HomeScreen = ({ navigation }) => {
  const { user, isAuthenticated, loading, logout } = useAuth();

  useEffect(() => {
    if (!loading && !isAuthenticated) {
      navigation.replace("Auth");
    }
  }, [isAuthenticated, loading, navigation]);

  useEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <TouchableOpacity
          onPress={async () => {
            const result = await logout();
            if (result.success) navigation.replace("Auth");
          }}
          style={{ marginRight: 10 }}
        >
          <Text style={{ color: "#f44336", fontWeight: "bold" }}>Logout</Text>
        </TouchableOpacity>
      ),
    });
  }, [navigation]);

  return (
    <View style={styles.container}>
      <Text style={styles.welcomeText}>Welcome, {user?.name || "User"}!</Text>
      <TouchableOpacity style={styles.button} onPress={() => navigation.navigate("Notes")}>
        <Text style={styles.buttonText}>View My Notes</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: "center", alignItems: "center", padding: 20, backgroundColor: "#f5f5f5" },
  welcomeText: { fontSize: 24, marginBottom: 20, textAlign: "center" },
  button: { backgroundColor: "#007BFF", padding: 15, borderRadius: 5, width: "80%", alignItems: "center" },
  buttonText: { color: "white", fontSize: 16, fontWeight: "bold" },
});

export default HomeScreen;
