<?php
include 'db.php';

$action = $_GET['action'];

if ($action == 'create') {
    $category_name = $_POST['category_name'];
    $description = $_POST['description'];

    $sql = "INSERT INTO categories (category_name, description) VALUES ('$category_name', '$description')";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Category created successfully"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
    }
}

if ($action == 'read') {
    $sql = "SELECT * FROM categories";
    $result = $conn->query($sql);
    $categories = [];
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $categories[] = $row;
        }
        echo json_encode($categories);
    } else {
        echo json_encode([]);
    }
}

$conn->close();
?>
