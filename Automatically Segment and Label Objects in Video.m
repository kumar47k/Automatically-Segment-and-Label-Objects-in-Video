% Set up Python environment (optional if already done)
pyenv('Version', 'E:\KIRAN\College\python\python.exe');  % e.g., C:\Users\YourName\anaconda3\envs\yolo\python.exe

% Import necessary Python packages
YOLO = py.importlib.import_module('ultralytics').YOLO;
cv2 = py.importlib.import_module('cv2');

% Load YOLOv8 model
model = YOLO("yolov8n.pt");

% Open video
videoPath = 'C:\Users\ADMIN\Documents\MATLAB\try.mp4';  % Adjust if needed
cap = cv2.VideoCapture(videoPath);

if ~cap.isOpened()
    error('Cannot open video file');
end

% Get video properties
width = int64(cap.get(py.getattr(cv2, 'CAP_PROP_FRAME_WIDTH')));
height = int64(cap.get(py.getattr(cv2, 'CAP_PROP_FRAME_HEIGHT')));
fps = double(cap.get(py.getattr(cv2, 'CAP_PROP_FPS')));

% Create output writer
fourcc = cv2.VideoWriter_fourcc('m','p','4','v');
out = cv2.VideoWriter('output.mp4', fourcc, fps, py.tuple([width, height]));

while true
    ret_frame = cap.read();
    if ~ret_frame{1}
        break;
    end
    frame = ret_frame{2};

    % Run detection
    results = model(frame);
    annotated_frame = results{1}.plot();

    % Convert and display frame in MATLAB
    img = uint8(annotated_frame);
    imshow(img);
    drawnow;

    % Save annotated frame
    out.write(annotated_frame);

    % Optionally break manually
    % break;
end

% Clean up
cap.release();
out.release();
