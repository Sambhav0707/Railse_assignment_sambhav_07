@echo off
echo Optimizing video files for GitHub...

echo.
echo Creating optimized MP4 (smaller file size)...
ffmpeg -i assets/railse_video.mp4 -vf "scale=640:-1" -c:v libx264 -crf 28 assets/railse_video_optimized.mp4

echo.
echo Creating GIF for inline viewing...
ffmpeg -i assets/railse_video.mp4 -vf "fps=10,scale=480:-1" assets/demo.gif

echo.
echo Optimization complete!
echo Files created:
echo - assets/railse_video_optimized.mp4 (smaller MP4)
echo - assets/demo.gif (GIF for inline viewing)
echo.
echo You can now update the README.md to use these optimized files.
pause
