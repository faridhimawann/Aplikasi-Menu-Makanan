<?php
include 'db.php';

$action = $_GET['action'];

if ($action == 'create') {

    $recipe_id = $_POST['id'];

    if ($recipe_id > 0) {
        $sql = "INSERT INTO favorites (recipe_id) VALUES ('$recipe_id')";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Recipe added to favorites"]);
        } else {
            echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "fail", "message" => "Invalid recipe ID"]);
    }
}

if ($action == 'read') {
    $sql = "SELECT receipts.*, categories.category_name FROM receipts LEFT JOIN categories ON receipts.category_id = categories.id JOIN favorites ON receipts.id = favorites.recipe_id";
    $result = $conn->query($sql);
    $favorites = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $favorites[] = $row;
        }
        echo json_encode($favorites);
    } else {
        echo json_encode([]);
    }
}


if ($action == 'delete') {
    $recipe_id = $_POST['id'];

    if ($recipe_id > 0) {
        $sql = "DELETE FROM favorites WHERE recipe_id = '$recipe_id'";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "Recipe removed from favorites"]);
        } else {
            echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "fail", "message" => "Invalid recipe ID"]);
    }
}

$conn->close();
?>
