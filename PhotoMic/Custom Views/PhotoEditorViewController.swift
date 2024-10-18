//
//  PhotoEditorViewController.swift
//  PhotoMic
//
//  Created by Yolima Pereira Ruiz on 16/10/24.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class PhotoEditorViewController: UIViewController {
    
    weak var delegate : PhotoEditorDelegate?
    private let model: PhotoEditorModel
    private let imageView = UIImageView()
    private let filterLabel = UILabel()
    private let grainPercentageLabel = UILabel()
    private let scratchesPercentageLabel = UILabel()
    private let grainSlider = UISlider()
    private let scratchesSlider = UISlider()
    private let context = CIContext() // For rendering Core Image filters
    
   
    
    init(model: PhotoEditorModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupCustomBackButton()
        setupCustomDoneButton()
        
        setupImageView()
        updateImageView()
        setupFilterLabel()
        setupGrainPercentageLabel()
        setupsScratchesPercentageLabel()
        setupGrainSlider()
        setupScratchesSlider()
        applyFilter()
    }
    
    private func setupCustomBackButton() {
     
        navigationItem.hidesBackButton = true
        let backButton = UIButton(type: .system)
        backButton.setTitle("Cancel", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        
        backButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    

    @objc private func customBackButtonTapped() {
       
        print("Botón de retroceso personalizado presionado")

        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupCustomDoneButton() {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
             
        let doneBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }

    @objc private func doneButtonTapped() {
        print("done tapped")
       
        model.editedImage = imageView.image
        delegate?.didFinishEditing(model.editedImage)
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupFilterLabel() {
        filterLabel.text = " Analog Film Filter"
        filterLabel.textColor = .white
        filterLabel.font = UIFont.boldSystemFont(ofSize: 24)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterLabel)
        
        NSLayoutConstraint.activate([
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -120)
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate ([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
    }
    
    private func setupGrainPercentageLabel() {
        grainPercentageLabel.text = "0% Grain" // Initial percentage
        grainPercentageLabel.font = UIFont.systemFont(ofSize: 20)
        grainPercentageLabel.textAlignment = .center
        grainPercentageLabel.textColor = .white
        
        grainPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(grainPercentageLabel)
        
        NSLayoutConstraint.activate([
            grainPercentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            grainPercentageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupsScratchesPercentageLabel() {
        scratchesPercentageLabel.text = "0% Scratch" // Initial percentage
        scratchesPercentageLabel.font = UIFont.systemFont(ofSize: 20)
        scratchesPercentageLabel.textAlignment = .center
        scratchesPercentageLabel.textColor = .white
        
        scratchesPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scratchesPercentageLabel)
        
        NSLayoutConstraint.activate([
            scratchesPercentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            scratchesPercentageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupGrainSlider() {
        grainSlider.minimumValue = 3
        grainSlider.maximumValue = 30
        grainSlider.value = 0
        grainSlider.tintColor = .systemBlue
        grainSlider.addTarget(self, action: #selector(grainSliderValueChanged(_:)), for: .valueChanged)
        
        grainSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(grainSlider)
        
        NSLayoutConstraint.activate([
            grainSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grainSlider.topAnchor.constraint(equalTo: grainPercentageLabel.bottomAnchor, constant: 80),
            grainSlider.widthAnchor.constraint(equalToConstant: 350)
        ])
        
    }
    
    private func setupScratchesSlider() {
        scratchesSlider.minimumValue = 6.5
        scratchesSlider.maximumValue = 65
        scratchesSlider.value = 0
        scratchesSlider.tintColor = .systemBlue
        scratchesSlider.addTarget(self, action: #selector(scratchSliderValueChanged(_:)), for: .valueChanged)
        
        scratchesSlider.translatesAutoresizingMaskIntoConstraints = false
        scratchesSlider.backgroundColor = .systemGray.withAlphaComponent(0.3)
        view.addSubview(scratchesSlider)
        
        NSLayoutConstraint.activate([
            scratchesSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scratchesSlider.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80),
            scratchesSlider.widthAnchor.constraint(equalToConstant: 350)
        ])
        
    }
    
    private func updateImageView(){
        imageView.image = model.editedImage
    }
    
    // MARK: - Actions
    
    @objc private func grainSliderValueChanged(_ sender: UISlider) {
        // Map the slider value from 3-30 to a percentage from 0-100

        let mappedValue = (sender.value - sender.minimumValue) / (sender.maximumValue - sender.minimumValue) * 100
        grainPercentageLabel.text = String(format: "%.0f%% Grain", mappedValue)
        applyFilter()
    }

    
    @objc private func scratchSliderValueChanged(_ sender: UISlider) {
        // Map the slider value from 0-65 to a percentage from 0-100
      
        let mappedValue = (sender.value - sender.minimumValue) / (sender.maximumValue - sender.minimumValue) * 100
        scratchesPercentageLabel.text = String(format: "%.0f%% Scratch", mappedValue)
        applyFilter()
    }
    
     private func applyFilter() {
      
        guard let originalUIImage = model.editedImage,
              let ciImage = CIImage(image: originalUIImage) else {
            return
        }
        
        // Apply the analog film effect filter
        guard let filteredCIImage = simulateAnalogFilmEffect(on: ciImage, grainIntensity: grainSlider.value, scratchIntensity: scratchesSlider.value) else { return }
        
        // Convert the filtered CIImage to UIImage
        if let cgImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
            let filteredUIImage = UIImage(cgImage: cgImage, scale: originalUIImage.scale, orientation: originalUIImage.imageOrientation)
            
            imageView.image = filteredUIImage
            
        }
    }
    
  
    
   
    func simulateAnalogFilmEffect(on inputImage: CIImage, grainIntensity: Float, scratchIntensity: Float) -> CIImage? {
    
        // Step 1: Apply the Sepia Tone Filter
        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.inputImage = inputImage
        sepiaFilter.intensity = 1.0
        guard let sepiaCIImage = sepiaFilter.outputImage else { return nil }
    
        // Step 2: Simulate Grain (White Specks)
        let randomNoise = CIFilter.randomGenerator()
        guard let noiseImage = randomNoise.outputImage else { return nil }
    
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x: 0, y: 0.005 * CGFloat(grainIntensity) / 100, z: 0, w: 0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
    
        let whiteningFilter = CIFilter.colorMatrix()
        whiteningFilter.inputImage = noiseImage
        whiteningFilter.rVector = whitenVector
        whiteningFilter.gVector = whitenVector
        whiteningFilter.bVector = whitenVector
        whiteningFilter.aVector = fineGrain
        whiteningFilter.biasVector = zeroVector
        guard let whiteSpecks = whiteningFilter.outputImage else { return nil }
    
        // Composite Specks over Sepia Image
        let speckCompositor = CIFilter.sourceOverCompositing()
        speckCompositor.inputImage = whiteSpecks
        speckCompositor.backgroundImage = sepiaCIImage
        guard let speckledImage = speckCompositor.outputImage else { return nil }
    
        // Step 3: Simulate Scratches
        let verticalScale = CGAffineTransform(scaleX: 1.5, y: 25)
        let transformedNoise = noiseImage.transformed(by: verticalScale)
    
        let darkenVector = CIVector(x: 4 * (1 - CGFloat(scratchIntensity) / 100), y: 0, z: 0, w: 0)
        
        let darkenBias = CIVector(x: 0, y: 1, z: 1, w: 1)
    
        let darkeningFilter = CIFilter.colorMatrix()
        darkeningFilter.inputImage = transformedNoise
        darkeningFilter.rVector = darkenVector
        darkeningFilter.gVector = zeroVector
        darkeningFilter.bVector = zeroVector
        darkeningFilter.aVector = zeroVector
        darkeningFilter.biasVector = darkenBias
        guard let darkScratchesPreGrayscale = darkeningFilter.outputImage else { return nil }
    
        // Convert Scratches to Grayscale
        let grayscaleFilter = CIFilter.minimumComponent()
        grayscaleFilter.inputImage = darkScratchesPreGrayscale
        guard let darkScratches = grayscaleFilter.outputImage else { return nil }
    
        // Step 4: Composite Scratches over Sepia Image with Grain
        let oldFilmCompositor = CIFilter.multiplyCompositing()
        oldFilmCompositor.inputImage = darkScratches
        oldFilmCompositor.backgroundImage = speckledImage
        guard let oldFilmImage = oldFilmCompositor.outputImage else { return nil }
    
        // Crop to original image extent
        return oldFilmImage.cropped(to: inputImage.extent)
    }
   
    
}


#Preview {
    PhotoEditorViewController(model: PhotoEditorModel(image: UIImage(named: "postcomida")))
}
