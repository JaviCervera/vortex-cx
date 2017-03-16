#define _IRR_STATIC_LIB_
#include "irrlicht/irrlicht.h"
#include "mesh.h"
#include "stringutils.h"
#include <algorithm>

using namespace irr;

// Link Irrlicht lib
#ifdef _MSC_VER
#pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:mainCRTStartup")
#pragma comment(lib, "Irrlicht.win32.lib")
#endif

// Menu ids
enum {
	BUTTON_CUBE,
	BUTTON_SPHERE,
	BUTTON_OPEN,
	BUTTON_SAVEXML,
	BUTTON_SAVEJSON,
	BUTTON_EXPORTMATERIALS,
	BUTTON_EXPORTNORMALS,
	BUTTON_EXPORTTANGENTS,
	BUTTON_EXPORTANIMATIONS
};

std::string W2S(const wchar_t* wstr);




// Event receiver
class MyEventReceiver : public IEventReceiver
{
public:
	MyEventReceiver() {
		mDevice = NULL;
		mMesh = NULL;
		mNode = NULL;
		mCam = NULL;
		mLastFilename = "";
		mExportMaterials = true;
		mExportNormals = true;
		mExportTangents = true;
		mExportAnimations = true;
	}

	virtual bool OnEvent(const SEvent& event) {
		if (event.EventType == EET_GUI_EVENT) {
			switch (event.GUIEvent.EventType) {
			case gui::EGET_BUTTON_CLICKED:
				switch (event.GUIEvent.Caller->getID()) {
				case BUTTON_CUBE:
					UpdateMesh(CreateCube(mDevice), "cube");
					break;
				case BUTTON_SPHERE:
					UpdateMesh(CreateSphere(mDevice), "sphere");
					break;
				case BUTTON_OPEN:
					mDevice->getGUIEnvironment()->addFileOpenDialog(L"Select Mesh File To Open:");
					break;
				case BUTTON_SAVEXML:
					if (mLastFilename != "") {
						bool exportLightmaps = false;
						if (ExtractExt(mLastFilename) == "pk3" && mExportMaterials) exportLightmaps = true;
						SaveMesh(mDevice, mMesh, (StripExt(mLastFilename) + ".msh.xml").c_str(), mExportMaterials, mExportNormals, mExportTangents, mExportAnimations, exportLightmaps);
					}
					break;
				}
				break;
			case gui::EGET_FILE_SELECTED:
			{
				std::string filename = W2S(static_cast<gui::IGUIFileOpenDialog*>(event.GUIEvent.Caller)->getFileName());
				UpdateMesh(LoadMesh(mDevice, filename), filename);
				break;
			}
			case gui::EGET_CHECKBOX_CHANGED:
			{
				gui::IGUICheckBox* checkbox = static_cast<gui::IGUICheckBox*>(event.GUIEvent.Caller);
				switch (event.GUIEvent.Caller->getID()) {
				case BUTTON_EXPORTMATERIALS:
					mExportMaterials = checkbox->isChecked();
					break;
				case BUTTON_EXPORTNORMALS:
					mExportNormals = checkbox->isChecked();
					break;
				case BUTTON_EXPORTTANGENTS:
					mExportTangents = checkbox->isChecked();
					break;
				case BUTTON_EXPORTANIMATIONS:
					mExportAnimations = checkbox->isChecked();
					break;
				}
				break;
			}
			default:
				break;
			}
		}

		return false;
	}

	void SetDevice(IrrlichtDevice* device) {
		mDevice = device;
		mDevice->setResizable(true);
		mDevice->setWindowCaption(L"Vortex Mesh Tool");
		mCam = mDevice->getSceneManager()->addCameraSceneNode();
	}

	IrrlichtDevice* GetDevice() {
		return mDevice;
	}

	scene::ICameraSceneNode* GetCamera() {
		return mCam;
	}

	void UpdateMesh(scene::IAnimatedMesh* mesh, const std::string& filename) {
		// remove previous scene node
		if (mNode) {
			mNode->removeAll();
			mNode->remove();
			mNode = NULL;
		}

		// Set new mesh
		mMesh = mesh;
		if ( mesh ) {
			// create scene node
			mNode = mDevice->getSceneManager()->addAnimatedMeshSceneNode(mMesh);

			// save filename
			mLastFilename = filename;

			// Relocate camera
			core::vector3df extents = mMesh->getBoundingBox().getExtent();
			float dimension = std::max(std::max(std::max(extents.X, extents.Y), extents.Z), 1.0f);
			mCam->setPosition(mMesh->getBoundingBox().getCenter() + core::vector3df(0, dimension, -dimension*2));
			mCam->updateAbsolutePosition();
			mCam->setTarget(mMesh->getBoundingBox().getCenter());
		} else {
			mLastFilename = "";
		}
	}
private:
	IrrlichtDevice* mDevice;
	scene::IAnimatedMesh* mMesh;
	scene::IAnimatedMeshSceneNode* mNode;
	scene::ICameraSceneNode* mCam;
	std::string mLastFilename;
	bool mExportMaterials;
	bool mExportNormals;
	bool mExportTangents;
	bool mExportAnimations;
};




int main(int, char* argv[]) {
	// Create event receiver
	MyEventReceiver eventReceiver;

	// create device and exit if creation failed
	video::E_DRIVER_TYPE driverType = video::EDT_OPENGL;
	IrrlichtDevice* device = createDevice(driverType, core::dimension2d<u32>(800, 600), 32, false, false, true, &eventReceiver);
	if (!device) return 1;
	eventReceiver.SetDevice(device);

	// On Mac, change to correct dir
#ifdef __APPLE__
	device->getFileSystem()->changeWorkingDirectoryTo(ExtractPath(argv[0]).c_str());
#endif

	// setup video driver
	device->getVideoDriver()->setTextureCreationFlag(video::ETCF_ALWAYS_32_BIT, true);

	// init gui
	gui::IGUIEnvironment* gui = device->getGUIEnvironment();;
	gui->getSkin()->setFont(gui->getFont("meshtool.data/fontlucida.png"));
	gui::IGUIToolBar* toolbar = gui->addToolBar();
	toolbar->addButton(BUTTON_CUBE, NULL, L"New Cube", device->getVideoDriver()->getTexture("meshtool.data/cube.png"), NULL, false, true);
	toolbar->addButton(BUTTON_SPHERE, NULL, L"New Sphere", device->getVideoDriver()->getTexture("meshtool.data/sphere.png"), NULL, false, true);
	toolbar->addButton(BUTTON_OPEN, NULL, L"Open Mesh", device->getVideoDriver()->getTexture("meshtool.data/folder.png"), NULL, false, true);
	toolbar->addButton(BUTTON_SAVEXML, NULL, L"Save XML Mesh", device->getVideoDriver()->getTexture("meshtool.data/xhtml.png"), NULL, false, true);
	//toolbar->addButton(MENU_SAVEJSON, NULL, L"Save JSON Mesh", gDriver->getTexture("meshtool.data/json.png"), NULL, false, true);
	gui->addCheckBox(true, core::rect<s32>(150, 4, 250, 23), NULL, BUTTON_EXPORTMATERIALS, L"Materials");
	gui->addCheckBox(true, core::rect<s32>(250, 4, 350, 23), NULL, BUTTON_EXPORTNORMALS, L"Normals");
	gui->addCheckBox(true, core::rect<s32>(350, 4, 450, 23), NULL, BUTTON_EXPORTTANGENTS, L"Tangents");
	gui->addCheckBox(true, core::rect<s32>(450, 4, 550, 23), NULL, BUTTON_EXPORTANIMATIONS, L"Animations");

	// setup camera;
	eventReceiver.GetCamera()->bindTargetAndRotation(true);
	eventReceiver.GetCamera()->setNearValue(0.1f);
	eventReceiver.GetCamera()->setFarValue(10000.0f);
	eventReceiver.GetCamera()->setFOV(1.047f);

	// main loop
	while (device->run()) {
		if (device->isWindowActive()) {
			// update camera ratio
			eventReceiver.GetCamera()->setAspectRatio(f32(device->getVideoDriver()->getScreenSize().Width) / device->getVideoDriver()->getScreenSize().Height);

			// draw
			device->getVideoDriver()->beginScene(true, true, video::SColor(255,200,200,200));
			device->getSceneManager()->drawAll();
			device->getGUIEnvironment()->drawAll();
			device->getVideoDriver()->endScene();
		} else device->yield();
	}

	device->drop();
	return 0;
}

std::string W2S(const wchar_t* wstr) {
	size_t len = wcslen(wstr);
	std::string str(len, ' ');
	wcstombs(&str[0], wstr, len);
	return str;
}
