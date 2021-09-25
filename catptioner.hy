(import [PIL [Image ImageFont ImageDraw]])

(defn get-full-caption[]
    (setv input-tone (input "Tone: ")
          tone (input-tone.upper)
          caption-text (input "Caption: ")
          full-caption (+ "[ " tone " ] " caption-text))
    (return full-caption))


(defn get-file-path[]
     (setv input-file-path (input "Enter path to file: "))
     (return input-file-path))


(defn get-output-name[]
     (setv output-name (input "Enter output file name: "))
     (return output-name))


(defn split-caption-lines[]
  (setv text (get-full-caption)
        split-strings [])
  (while (> (len text) 0)
    (if (< (len text) 42)
        (do
          (split-strings.append text)
          (break)))
    (setv line-length (text.rfind " " 0 42))
    (split-strings.append (cut text None line-length))
    (setv text (cut text line-length None)))
  (if (>= (len split-strings) 4)
      (do
        (print "The caption is too long, please type a shorter caption\n")
        (return (split-caption-lines))))
  (return split-strings))

(defn draw-text []
  (setv img (Image.open (get-file-path))
        font (ImageFont.truetype "cinecavDmono.ttf" 19))

  (setv (, x y)(, 20 436)
        (, imgw imgh) img.size)
  
  (if-not (= (, imgw imgh) (, 710 473))
          (do
            (print (+ "The image is " (str imgw) "x" (str imgh) ".\nResizing image to 710x473"))
            (setv img (img.resize (, 710 473) Image.ANTIALIAS)))
          (print "The image is the recommended size."))

  (setv caption-text (split-caption-lines)
        draw (ImageDraw.Draw img))

  (for [line (reversed caption-text)]
    (setv (, w h) (font.getsize line))

    (draw.rectangle (, x y (+ x w)(+ y h)) :fill "black")
    (draw.text (, x y) line :fill "white" :font font)
    
    (setv y (- y 23)))

  (img.save (+ (get-output-name) ".jpg")))

(draw-text)
