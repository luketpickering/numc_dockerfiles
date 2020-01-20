// Copyright 2016 L. Pickering, P Stowell, R. Terri, C. Wilkinson, C. Wret

/*******************************************************************************
 *    This file is part of NUISANCE.
 *
 *    NUISANCE is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    NUISANCE is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with NUISANCE.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/

#include "FitEvent.h"
#include "Measurement1D.h"

class T2KNOvAFlatTree : public Measurement1D {

  TTree *eventVariables;
  std::vector<FitParticle *> partList;
  std::vector<FitParticle *> initList;

  int Mode;
  bool cc;
  bool isNN;
  bool isNP;
  int PDGnu;
  int tgt;
  int tgta;
  int tgtz;
  int PDGLep;
  float ELep;
  float PLep;
  float CosLep;

  // Basic interaction kinematics
  float Q2;
  float q0;
  float q3;
  float Enu_QE;
  float Enu_true;
  float Q2_QE;
  float W_nuc_rest;
  float x;
  float y;
  float Eav;
  float EavAlt;
  float dalphat;
  float dpt;
  float dphit;
  float pnreco_C;

  bool Scaleplep;

  std::string subdir;

  // Save outgoing particle vectors
  int nfsp;
  static const int kMAX = 200;
  float px[kMAX];
  float py[kMAX];
  float pz[kMAX];
  float E[kMAX];
  int pdg[kMAX];
  int pdg_rank[kMAX];

  // Save incoming particle info
  int ninitp;
  int NumISN;
  int NumISP;
  float px_init[kMAX];
  float py_init[kMAX];
  float pz_init[kMAX];
  float E_init[kMAX];
  int pdg_init[kMAX];

  float AccWeight_q0q3;
  float AccWeight_ptheta;
  float AccWeight_enuy;
  double RWWeight;

  // Generic signal flags
  bool flagCCINC;
  bool flagNCINC;
  bool flagCCQE;
  bool flagCC0pi;
  bool flagCCQELike;
  bool flagNCEL;
  bool flagNC0pi;
  bool flagCCcoh;
  bool flagNCcoh;
  bool flagCC1pip;
  bool flagNC1pip;
  bool flagCC1pim;
  bool flagNC1pim;
  bool flagCC1pi0;
  bool flagNC1pi0;

  TFile *accHistFile;
  TH2 *accHist_q0q3;
  TH2 *accHist_ptheta;
  TH2 *accHist_enuy;

public:
  T2KNOvAFlatTree(nuiskey samplekey) {

    // Setup common settings
    fSettings = LoadSampleSettings(samplekey);

    fSettings.SetTitle("T2K-NOvA Studies");
    fSettings.SetEnuRange(0.0, 100);
    fSettings.SetAllowedTypes("EVT/SHAPE/DIAG", "EVT/SHAPE/DIAG");
    fSettings.DefineAllowedTargets("*");
    fSettings.DefineAllowedSpecies("numu");

    FinaliseSampleSettings();

    fScaleFactor = (PredictedEventRate("width") / double(fNEvents)) /
                   TotalIntegratedFlux("width");

    if (samplekey.Has("odir")) {
      subdir = samplekey.GetS("odir");
    }

    // Dummy stuff for NUISANCE
    fDataHist = new TH1D((fSettings.GetName() + "_data").c_str(),
                         fSettings.GetFullTitles().c_str(), 1, 0, 1);

    accHistFile = nullptr;
    accHist_q0q3 = nullptr;
    accHist_ptheta = nullptr;
    accHist_enuy = nullptr;

    Scaleplep = false;
    if (samplekey.Has("acc_map_file")) {
      accHistFile = new TFile(samplekey.GetS("acc_map_file").c_str());
      if (!accHistFile || !accHistFile->IsOpen()) {
        NUIS_ABORT("Failed to open " << samplekey.GetS("acc_map_file")
                                     << " for reading.");
      }
      if (samplekey.Has("acc_map_hist_q0q3")) {
        accHistFile->GetObject(samplekey.GetS("acc_map_hist_q0q3").c_str(),
                               accHist_q0q3);
        if (!accHist_q0q3) {
          NUIS_ABORT("Failed to read "
                     << samplekey.GetS("acc_map_hist_q0q3") << " from "
                     << samplekey.GetS("acc_map_file") << ".");
        }
      }
      if (samplekey.Has("acc_map_hist_ptheta")) {
        accHistFile->GetObject(samplekey.GetS("acc_map_hist_ptheta").c_str(),
                               accHist_ptheta);
        if (!accHist_ptheta) {
          NUIS_ABORT("Failed to read "
                     << samplekey.GetS("acc_map_hist_ptheta") << " from "
                     << samplekey.GetS("acc_map_file") << ".");
        }

        if (accHist_ptheta->GetYaxis()->GetBinUpEdge(
                accHist_ptheta->GetYaxis()->GetNbins() / 2) > 500) {
          Scaleplep = true;
        }
      }
      if (samplekey.Has("acc_map_hist_enuy")) {
        accHistFile->GetObject(samplekey.GetS("acc_map_hist_enuy").c_str(),
                               accHist_enuy);
        if (!accHist_enuy) {
          NUIS_ABORT("Failed to read "
                     << samplekey.GetS("acc_map_hist_enuy") << " from "
                     << samplekey.GetS("acc_map_file") << ".");
        }
      }
    }

    eventVariables = nullptr;
    FinaliseMeasurement();
  };

  void InitTree() {
    TDirectory *ogdir = gDirectory;
    TDirectory *odir = Config::Get().out;
    if (subdir.size()) {
      odir = odir->mkdir(subdir.c_str());
      odir->cd();
    }

    eventVariables = new TTree("T2KNOvATruthTree", "");
    eventVariables->SetDirectory(odir);
    eventVariables->Branch("Mode", &Mode, "Mode/I");
    eventVariables->Branch("cc", &cc, "cc/O");
    eventVariables->Branch("isNN", &isNN, "isNN/O");
    eventVariables->Branch("isNP", &isNP, "isNP/O");
    eventVariables->Branch("PDGnu", &PDGnu, "PDGnu/I");
    eventVariables->Branch("Enu_true", &Enu_true, "Enu_true/F");
    eventVariables->Branch("tgt", &tgt, "tgt/I");
    eventVariables->Branch("tgta", &tgta, "tgta/I");
    eventVariables->Branch("tgtz", &tgtz, "tgtz/I");
    eventVariables->Branch("PDGLep", &PDGLep, "PDGLep/I");
    eventVariables->Branch("ELep", &ELep, "ELep/F");
    eventVariables->Branch("PLep", &PLep, "PLep/F");
    eventVariables->Branch("CosLep", &CosLep, "CosLep/F");

    // Basic interaction kinematics
    eventVariables->Branch("Q2", &Q2, "Q2/F");
    eventVariables->Branch("q0", &q0, "q0/F");
    eventVariables->Branch("q3", &q3, "q3/F");
    eventVariables->Branch("Enu_QE", &Enu_QE, "Enu_QE/F");
    eventVariables->Branch("Q2_QE", &Q2_QE, "Q2_QE/F");
    eventVariables->Branch("W_nuc_rest", &W_nuc_rest, "W_nuc_rest/F");
    eventVariables->Branch("x", &x, "x/F");
    eventVariables->Branch("y", &y, "y/F");
    eventVariables->Branch("Eav", &Eav, "Eav/F");
    eventVariables->Branch("EavAlt", &EavAlt, "EavAlt/F");

    eventVariables->Branch("dalphat", &dalphat, "dalphat/F");
    eventVariables->Branch("dpt", &dpt, "dpt/F");
    eventVariables->Branch("dphit", &dphit, "dphit/F");
    eventVariables->Branch("pnreco_C", &pnreco_C, "pnreco_C/F");

    // Save outgoing particle vectors
    eventVariables->Branch("nfsp", &nfsp, "nfsp/I");
    eventVariables->Branch("px", px, "px[nfsp]/F");
    eventVariables->Branch("py", py, "py[nfsp]/F");
    eventVariables->Branch("pz", pz, "pz[nfsp]/F");
    eventVariables->Branch("E", E, "E[nfsp]/F");
    eventVariables->Branch("pdg", pdg, "pdg[nfsp]/I");
    eventVariables->Branch("pdg_rank", pdg_rank, "pdg_rank[nfsp]/I");

    // Save init particle vectors
    eventVariables->Branch("ninitp", &ninitp, "ninitp/I");
    eventVariables->Branch("px_init", px_init, "px_init[ninitp]/F");
    eventVariables->Branch("py_init", py_init, "py_init[ninitp]/F");
    eventVariables->Branch("pz_init", pz_init, "pz_init[ninitp]/F");
    eventVariables->Branch("E_init", E_init, "E_init[ninitp]/F");
    eventVariables->Branch("pdg_init", pdg_init, "pdg_init[ninitp]/I");
    eventVariables->Branch("NumISN", &NumISN, "NumISN/I");
    eventVariables->Branch("NumISP", &NumISP, "NumISP/I");

    // Event Scaling Information
    eventVariables->Branch("RWWeight", &RWWeight, "RWWeight/D");
    eventVariables->Branch("fScaleFactor", &fScaleFactor, "fScaleFactor/D");
    eventVariables->Branch("AccWeight_q0q3", &AccWeight_q0q3,
                           "AccWeight_q0q3/F");
    eventVariables->Branch("AccWeight_ptheta", &AccWeight_ptheta,
                           "AccWeight_ptheta/F");
    eventVariables->Branch("AccWeight_enuy", &AccWeight_enuy,
                           "AccWeight_enuy/F");

    eventVariables->Branch("flagCCINC", &flagCCINC, "flagCCINC/O");
    eventVariables->Branch("flagNCINC", &flagNCINC, "flagNCINC/O");
    eventVariables->Branch("flagCCQE", &flagCCQE, "flagCCQE/O");
    eventVariables->Branch("flagCC0pi", &flagCC0pi, "flagCC0pi/O");
    eventVariables->Branch("flagCCQELike", &flagCCQELike, "flagCCQELike/O");
    eventVariables->Branch("flagNCEL", &flagNCEL, "flagNCEL/O");
    eventVariables->Branch("flagNC0pi", &flagNC0pi, "flagNC0pi/O");
    eventVariables->Branch("flagCCcoh", &flagCCcoh, "flagCCcoh/O");
    eventVariables->Branch("flagNCcoh", &flagNCcoh, "flagNCcoh/O");
    eventVariables->Branch("flagCC1pip", &flagCC1pip, "flagCC1pip/O");
    eventVariables->Branch("flagNC1pip", &flagNC1pip, "flagNC1pip/O");
    eventVariables->Branch("flagCC1pim", &flagCC1pim, "flagCC1pim/O");
    eventVariables->Branch("flagNC1pim", &flagNC1pim, "flagNC1pim/O");
    eventVariables->Branch("flagCC1pi0", &flagCC1pi0, "flagCC1pi0/O");
    eventVariables->Branch("flagNC1pi0", &flagNC1pi0, "flagNC1pi0/O");

    if (ogdir) {
      ogdir->cd();
    }
  }

  virtual ~T2KNOvAFlatTree(){};

  //! Grab info from event
  void FillEventVariables(FitEvent *event) {
    ResetVariables();

    // Get the incoming neutrino and outgoing lepton
    FitParticle *nu = event->GetBeamPart();
    FitParticle *lep = event->GetHMFSMuon();

    PDGnu = nu->fPID;

    // Generic signal flags
    flagCCINC = SignalDef::isCCINC(event, PDGnu);
    flagNCINC = SignalDef::isNCINC(event, PDGnu);
    flagCCQE = SignalDef::isCCQE(event, PDGnu);
    flagCCQELike = SignalDef::isCCQELike(event, PDGnu);
    flagCC0pi = SignalDef::isCC0pi(event, PDGnu);
    flagNCEL = SignalDef::isNCEL(event, PDGnu);
    flagNC0pi = SignalDef::isNC0pi(event, PDGnu);
    flagCCcoh = SignalDef::isCCCOH(event, PDGnu, 211);
    flagNCcoh = SignalDef::isNCCOH(event, PDGnu, 111);
    flagCC1pip = SignalDef::isCC1pi(event, PDGnu, 211);
    flagNC1pip = SignalDef::isNC1pi(event, PDGnu, 211);
    flagCC1pim = SignalDef::isCC1pi(event, PDGnu, -211);
    flagNC1pim = SignalDef::isNC1pi(event, PDGnu, -211);
    flagCC1pi0 = SignalDef::isCC1pi(event, PDGnu, 111);
    flagNC1pi0 = SignalDef::isNC1pi(event, PDGnu, 111);

    // Now fill the information
    Mode = event->Mode;
    cc = event->IsCC();

    PDGnu = nu->fPID;
    Enu_true = nu->fP.E() / 1E3;
    tgt = event->fTargetPDG;
    tgta = event->fTargetA;
    tgtz = event->fTargetZ;

    RWWeight = event->RWWeight;

    if (!lep) {
      return;
    }

    PDGLep = lep->fPID;
    ELep = lep->fP.E() / 1E3;
    PLep = lep->fP.Vect().Mag() / 1E3;
    CosLep = cos(nu->fP.Vect().Angle(lep->fP.Vect()));

    // Basic interaction kinematics
    Q2 = -1 * (nu->fP - lep->fP).Mag2() / 1E6;
    q0 = (nu->fP - lep->fP).E() / 1E3;
    q3 = (nu->fP - lep->fP).Vect().Mag() / 1E3;

    // Get W_true with assumption of initial state nucleon at rest
    float m_n = (float)PhysConst::mass_proton;
    // Q2 assuming nucleon at rest
    W_nuc_rest = sqrt(-Q2 + 2 * m_n * q0 + m_n * m_n);
    // True Q2
    x = Q2 / (2 * m_n * q0);
    y = 1 - ELep / Enu_true;

    if (accHist_q0q3) {
      AccWeight_q0q3 =
          accHist_q0q3->GetBinContent(accHist_q0q3->GetXaxis()->FindBin(q3),
                                      accHist_q0q3->GetYaxis()->FindBin(q0));
    }
    if (accHist_ptheta) {
      AccWeight_ptheta = accHist_ptheta->GetBinContent(
          accHist_ptheta->GetXaxis()->FindBin(CosLep),
          accHist_ptheta->GetYaxis()->FindBin(Scaleplep ? PLep * 1E3 : PLep));
    }
    if (accHist_enuy) {
      AccWeight_enuy = accHist_enuy->GetBinContent(
          accHist_enuy->GetXaxis()->FindBin(y),
          accHist_enuy->GetYaxis()->FindBin(Enu_true));
    }

    // These assume C12 binding from MINERvA... not ideal
    Enu_QE = FitUtils::EnuQErec(lep->fP, CosLep, 34., true);
    Q2_QE = FitUtils::Q2QErec(lep->fP, CosLep, 34., true);

    Eav = FitUtils::GetErecoil_MINERvA_LowRecoil(event) / 1.E3;
    EavAlt = FitUtils::Eavailable(event) / 1.E3;

    dalphat = FitUtils::Get_STV_dalphat(event, PDGnu, true);
    dpt = FitUtils::Get_STV_dpt(event, PDGnu, true);
    dphit = FitUtils::Get_STV_dphit(event, PDGnu, true);
    pnreco_C = FitUtils::Get_pn_reco_C(event, PDGnu, true);

    // Loop over the particles and store all the final state particles in a
    // vector
    for (UInt_t i = 0; i < event->Npart(); ++i) {

      if (event->PartInfo(i)->fIsAlive &&
          event->PartInfo(i)->Status() == kFinalState)
        partList.push_back(event->PartInfo(i));

      if (event->PartInfo(i)->IsInitialState())
        initList.push_back(event->PartInfo(i));
    }

    // Save outgoing particle vectors
    nfsp = (int)partList.size();
    std::map<int, std::vector<std::pair<double, int>>> pdgMap;

    for (int i = 0; i < nfsp; ++i) {
      px[i] = partList[i]->fP.X() / 1E3;
      py[i] = partList[i]->fP.Y() / 1E3;
      pz[i] = partList[i]->fP.Z() / 1E3;
      E[i] = partList[i]->fP.E() / 1E3;
      pdg[i] = partList[i]->fPID;
      pdgMap[pdg[i]].push_back(std::make_pair(partList[i]->fP.Vect().Mag(), i));
    }

    for (std::map<int, std::vector<std::pair<double, int>>>::iterator iter =
             pdgMap.begin();
         iter != pdgMap.end(); ++iter) {
      std::vector<std::pair<double, int>> thisVect = iter->second;
      std::sort(thisVect.begin(), thisVect.end());

      // Now save the order... a bit funky to avoid inverting
      int nPart = (int)thisVect.size() - 1;
      for (int i = nPart; i >= 0; --i) {
        pdg_rank[thisVect[i].second] = nPart - i;
      }
    }

    // Save init particles
    ninitp = (int)initList.size();
    for (int i = 0; i < ninitp; ++i) {
      px_init[i] = initList[i]->fP.X() / 1E3;
      py_init[i] = initList[i]->fP.Y() / 1E3;
      pz_init[i] = initList[i]->fP.Z() / 1E3;
      E_init[i] = initList[i]->fP.E() / 1E3;
      pdg_init[i] = initList[i]->fPID;
      NumISN += int(pdg_init[i] == 2112);
      NumISP += int(pdg_init[i] == 2212);
    }

    // if (event->fType == kNEUT) {
    //   // Do something with NEUT
    // } else f (event->fType == kGENIE) {
    //   //Do something with GENIE
    // }

    if (abs(Mode) == 2) {
      if ((event->fType == kNEUT) && (ninitp >= 3)) {
        isNN = (NumISP == 2) || (NumISN == 2);
        isNP = (NumISN == 1);
      } else if (event->fType == kGENIE) {
        genie::Target const &tgt =
            static_cast<genie::GHepRecord *>(event->genie_event->event)
                ->Summary()
                ->InitState()
                .Tgt();
        size_t nuc_pdg = tgt.HitNucPdg();

        switch (nuc_pdg - 2000000200) {
        case 0:
        case 2: {
          isNN = true;
          isNP = false;
          break;
        }
        case 1: {
          isNP = true;
          isNN = false;
          break;
        }
        }
      }
    }

    // Fill the eventVariables Tree
    eventVariables->Fill();
  }

  void ResetVariables() {
    if (!eventVariables) {
      InitTree();
    }
    cc = false;
    isNN = false;
    isNP = false;
    NumISN = 0;
    NumISP = 0;
    // Reset all Function used to extract any variables of interest to the
    // event
    Mode = PDGnu = tgt = tgta = tgtz = PDGLep = 0;

    Enu_true = ELep = CosLep = Q2 = q0 = q3 = Enu_QE = Q2_QE = W_nuc_rest = x =
        y = Eav = EavAlt = -999.9;

    // Other fun variables
    // MINERvA-like ones
    dalphat = dpt = dphit = pnreco_C = -999.99;

    nfsp = ninitp = 0;
    for (int i = 0; i < kMAX; ++i) {
      px[i] = py[i] = pz[i] = E[i] = -999;
      pdg[i] = pdg_rank[i] = 0;

      px_init[i] = py_init[i] = pz_init[i] = E_init[i] = -999;
      pdg_init[i] = 0;
    }

    partList.clear();
    initList.clear();

    AccWeight_q0q3 = 0;
    AccWeight_ptheta = 0;
    AccWeight_enuy = 0;

    flagCCINC = flagNCINC = flagCCQE = flagCC0pi = flagCCQELike = flagNCEL =
        flagNC0pi = flagCCcoh = flagNCcoh = flagCC1pip = flagNC1pip =
            flagCC1pim = flagNC1pim = flagCC1pi0 = flagNC1pi0 = false;
  }

  //! Define this samples signal
  bool isSignal(FitEvent *nvect) { return true; }

  //! Write Files
  void Write(std::string drawOpt) {
    Config::Get().out->cd();
    Measurement1D::Write(drawOpt);
    eventVariables->Write();
    if (accHist_q0q3) {
      accHist_q0q3->Write();
    }

    if (accHist_ptheta) {
      accHist_ptheta->Write();
    }

    if (accHist_enuy) {
      accHist_enuy->Write();
    }
  }
};
