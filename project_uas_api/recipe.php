<?php
include 'db.php';

$action = $_GET['action'];

if ($action == 'create') {
    $name = $_POST['name'];
    $category_id = $_POST['category_id'];
    
    // Proses unggah gambar
    $image = $_FILES['image']['name'];
    $target_dir = "foto/";
    $target_file = $target_dir . basename($image);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
    
    // Periksa apakah file gambar atau bukan
    $check = getimagesize($_FILES['image']['tmp_name']);
    if ($check !== false) {
        $uploadOk = 1;
    } else {
        echo json_encode(["status" => "fail", "message" => "File is not an image."]);
        $uploadOk = 0;
    }
    
    
    // Periksa ukuran file
    if ($_FILES['image']['size'] > 500000) {
        echo json_encode(["status" => "fail", "message" => "Sorry, your file is too large."]);
        $uploadOk = 0;
    }
    
    // Izinkan format file tertentu
    if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") {
        echo json_encode(["status" => "fail", "message" => "Sorry, only JPG, JPEG, PNG & GIF files are allowed."]);
        $uploadOk = 0;
    }
    
    // Periksa jika $uploadOk bernilai 0
    if ($uploadOk == 0) {
        echo json_encode(["status" => "fail", "message" => "Sorry, your file was not uploaded."]);
    // Jika semuanya baik, coba unggah file
    } else {
        if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
            // Insert data ke database
            $sql = "INSERT INTO receipts (name, category_id, image) VALUES ('$name', '$category_id', '$target_file')";
            if ($conn->query($sql) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Receipt created successfully"]);
            } else {
                echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
            }
        } else {
            echo json_encode(["status" => "fail", "message" => "Sorry, there was an error uploading your file."]);
        }
    }
}

if ($action == 'read') {
    $sql = "SELECT receipts.*, categories.category_name FROM receipts LEFT JOIN categories ON receipts.category_id = categories.id";
    $result = $conn->query($sql);
    $receipts = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $receipts[] = $row;
        }
        echo json_encode($receipts);
    } else {
        echo json_encode([]);
    }
}

if ($action == 'update') {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $category_id = $_POST['category_id'];
    $image = $_FILES['image']['name'];

    $updateQuery = "UPDATE receipts SET name='$name', category_id='$category_id'";

    if (!empty($image)) {
        $target_dir = "foto/";
        $target_file = $target_dir . basename($image);
        $uploadOk = 1;
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

        // Periksa apakah file gambar atau bukan
        $check = getimagesize($_FILES['image']['tmp_name']);
        if ($check !== false) {
            $uploadOk = 1;
        } else {
            echo json_encode(["status" => "fail", "message" => "File is not an image."]);
            $uploadOk = 0;
        }


        // Periksa ukuran file
        if ($_FILES['image']['size'] > 500000) {
            echo json_encode(["status" => "fail", "message" => "Sorry, your file is too large."]);
            $uploadOk = 0;
        }

        // Izinkan format file tertentu
        if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") {
            echo json_encode(["status" => "fail", "message" => "Sorry, only JPG, JPEG, PNG & GIF files are allowed."]);
            $uploadOk = 0;
        }

        // Periksa jika $uploadOk bernilai 0
        if ($uploadOk == 0) {
            echo json_encode(["status" => "fail", "message" => "Sorry, your file was not uploaded."]);
        // Jika semuanya baik, coba unggah file
        } else {
            if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
                $updateQuery .= ", image='$target_file'";
            } else {
                echo json_encode(["status" => "fail", "message" => "Sorry, there was an error uploading your file."]);
                exit();
            }
        }
    }

    $updateQuery .= " WHERE id='$id'";
    
    if ($conn->query($updateQuery) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Receipt updated successfully"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
    }
}

if ($action == 'delete') {
    $id = $_POST['id'];
    $sql = "DELETE FROM receipts WHERE id='$id'";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Receipt deleted successfully"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Error: " . $conn->error]);
    }
}

$conn->close();
?>
