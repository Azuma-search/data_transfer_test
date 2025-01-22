// -*- C++ -*-
/*!
 * @file
 * @brief
 * @date
 * @author
 *
 */

#include "SliTDaqmwReader1.h"

using DAQMW::FatalType::DATAPATH_DISCONNECTED;
using DAQMW::FatalType::OUTPORT_ERROR;
using DAQMW::FatalType::USER_DEFINED_ERROR1; // parse error
using DAQMW::FatalType::USER_DEFINED_ERROR2; // socket fatal error
using DAQMW::FatalType::USER_DEFINED_ERROR3; // socket timeout
using DAQMW::FatalType::USER_DEFINED_ERROR4; // wrong data format
using DAQMW::FatalType::USER_DEFINED_ERROR5; // wrong number of footer in an event
//using DAQMW::FatalType::USER_DEFINED_ERROR6; // event number shift (for cosmic mode)
//using DAQMW::FatalType::USER_DEFINED_ERROR7; // check if the reset is done

// Module specification
// Change following items to suit your component's spec.
static const char* slitdaqmwreader1_spec[] =
  {
   "implementation_id", "SliTDaqmwReader1",
   "type_name",         "SliTDaqmwReader1",
   "description",       "SliTDaqmwReader1 component",
   "version",           "1.0",
   "vendor",            "Yutaro Sato, Niigata Univ.",
   "category",          "example",
   "activity_type",     "DataFlowComponent",
   "max_instance",      "1",
   "language",          "C++",
   "lang_type",         "compile",
   ""
  };

SliTDaqmwReader1::SliTDaqmwReader1(RTC::Manager* manager)
  : DAQMW::DaqComponentBase(manager),
    m_OutPort("slitdaqmwreader1_out", m_out_data),
    m_sock(0),
    m_recvByteSize(0),
    m_out_status(BUF_SUCCESS),
    m_isTimeOutFatal(false),
    m_timeOut_sec(20),
    m_firmwareVersion(1)
{
  // Registration: InPort/OutPort/Service

  // Set OutPort buffers
  registerOutPort("slitdaqmwreader1_out", m_OutPort);

  init_command_port();
  init_state_table();
  set_comp_name("SliTDaqmwReader1");
}

SliTDaqmwReader1::~SliTDaqmwReader1()
{
}

RTC::ReturnCode_t SliTDaqmwReader1::onInitialize()
{
  if (m_debug) {
    std::cerr << "SliTDaqmwReader1::onInitialize()" << std::endl;
  }

  return RTC::RTC_OK;
}

RTC::ReturnCode_t SliTDaqmwReader1::onExecute(RTC::UniqueId ec_id)
{
  daq_do();

  return RTC::RTC_OK;
}

int SliTDaqmwReader1::daq_dummy()
{
  return 0;
}

int SliTDaqmwReader1::daq_configure()
{
  std::cerr << "*** SliTDaqmwReader1::configure" << std::endl;

  ::NVList* paramList;
  paramList = m_daq_service0.getCompParams();
  parse_params(paramList);
  create_buffer_ipaddress();

  return 0;
}

int SliTDaqmwReader1::parse_params(::NVList* list)
{
  bool srcAddrSpecified = false;
  bool srcPortSpecified = false;

  std::cerr << "param list length:" << (*list).length() << std::endl;

  int len = (*list).length();
  for (int i = 0; i < len; i+=2) {
    std::string sname  = (std::string)(*list)[i].value;
    std::string svalue = (std::string)(*list)[i+1].value;

    std::cerr << "sname: " << sname << "  ";
    std::cerr << "value: " << svalue << std::endl;

    if ( sname == "debugMessage" ) {
      if (m_debug) {
	std::cerr << "debugMessage: " << svalue << std::endl;
      }
      char* offset;
      m_debug = (bool)strtol(svalue.c_str(), &offset, 10);
    }
    
    if ( sname == "firmwareVersion" ) {
      if (m_debug) {
	std::cerr << "firmwareVersion: " << svalue << std::endl;
      }
      char* offset;
      m_firmwareVersion = (int)strtol(svalue.c_str(), &offset, 10);
    }
    
    if ( sname == "srcAddr" ) {
      srcAddrSpecified = true;
      if (m_debug) {
	std::cerr << "source addr: " << svalue << std::endl;
      }
      m_srcAddr = svalue;
    }
    
    if ( sname == "qvId" ){
      srcAddrSpecified = true;
      char* offset;
      m_qvId    = (int)strtol(svalue.c_str(), &offset, 10);
      m_boardId = SliTSetup::getBoardIdfromQuarterVaneId(m_qvId);
      m_srcAddr = SliTSetup::getIpAddressfromQuarterVaneId(m_qvId);
      if (m_debug) {
	std::cerr << "board#" << m_boardId << "(qv#" << m_qvId << ") : ip = " << m_srcAddr << std::endl;
      }
    }
    
    if ( sname == "boardId" ){
      srcAddrSpecified = true;
      char* offset;
      m_boardId = (int)strtol(svalue.c_str(), &offset, 10);
      m_qvId    = SliTSetup::getQuarterVaneIdfromBoardId(m_boardId);
      m_srcAddr = SliTSetup::getIpAddressfromQuarterVaneId(m_qvId);
      if (m_debug) {
	std::cerr << "board#" << m_boardId << "(qv#" << m_qvId << ") : ip = " << m_srcAddr << std::endl;
      }
    }
    
    if ( sname == "srcPort" ) {
      srcPortSpecified = true;
      if (m_debug) {
	std::cerr << "source port: " << svalue << std::endl;
      }
      char* offset;
      m_srcPort = (int)strtol(svalue.c_str(), &offset, 10);
    }

    if ( sname == "isStoreOneEventData" ) {
      if (m_debug) {
	std::cerr << "isStreOneEventData: " << svalue << std::endl;
      }
      char* offset;
      m_isStoreOneEventData = (bool)strtol(svalue.c_str(), &offset, 10);
    }

    if ( sname == "isTimeOutFatal" ) {
      if (m_debug) {
	std::cerr << "isTimeOutFatal: " << svalue << std::endl;
      }
      char* offset;
      m_isTimeOutFatal = (bool)strtol(svalue.c_str(), &offset, 10);
    }
    
    if ( sname == "timeOut_sec" ) {
      if (m_debug) {
	std::cerr << "TimeOut_sec: " << svalue << std::endl;
      }
      char* offset;
      m_timeOut_sec = (float)strtof(svalue.c_str(), &offset);
    }
  }
  
  if (!srcAddrSpecified) {
    std::cerr << "### ERROR:data source address not specified\n";
    fatal_error_report(USER_DEFINED_ERROR1, "NO SRC ADDRESS");
  }
  if (!srcPortSpecified) {
    std::cerr << "### ERROR:data source port not specified\n";
    fatal_error_report(USER_DEFINED_ERROR1, "NO SRC PORT");
  }

  return 0;
}

int SliTDaqmwReader1::daq_unconfigure()
{
  std::cerr << "*** SliTDaqmwReader1::unconfigure" << std::endl;

  if( m_slitReader ){
    delete m_slitReader;
    m_slitReader = 0;
  }

  if( m_slitController ){
    delete m_slitController;
    m_slitController = 0;
  }

  if( m_slitBDF ){
    delete m_slitBDF;
    m_slitBDF = 0;
  }

  if( m_data ){
    delete m_data;
    m_data = 0;
  }

  return 0;
}

int SliTDaqmwReader1::daq_start()
{
  std::cerr << "*** SliTDaqmwReader1::start" << std::endl;

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // to be updated // tmpppp
  /*
    if( !m_slitController ) m_slitController = new SliTController( m_firmwareVersion );
    if( m_slitController->getResetFlag(m_boardid)==0x00 ){
    std::cerr << "### ERROR:Not yet reset\n";
    fatal_error_report(USER_DEFINED_ERROR7, "NOT YET RESET");
    }else if( m_slitController->recoveryProcess(m_boardid) ){
    std::cerr << "### ERROR:wrong chip status\n";
    m_slitController->dropResetFlag(m_boardid);
    fatal_error_report(USER_DEFINED_ERROR5, "WRONG CHIP STATUS");
    }
    m_slitController->printStatus(m_boardid);
  */
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  m_flReadHeader         = true;
  m_flIsTimeOut          = false;
  m_flIsDetectFooter     = false;
  m_flIsDetectEndOfEvent = false;
  m_eventDataLength      =  0;
  m_prevEventNumber      = -1;
  m_cntIsLastData        =  0;
  m_out_status           = BUF_SUCCESS;

  try {
    // Create socket and connect to data server.
    m_sock = new DAQMW::Sock();
    m_sock->connect(m_srcAddr, m_srcPort);
    m_sock->setOptRecvTimeOut(m_timeOut_sec); // sec (default value was 2 sec which is defined in /usr/include/daqmw/Sock.h)
  } catch (DAQMW::SockException& e) {
    std::cerr << "Sock Fatal Error : " << e.what() << std::endl;
    fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
  } catch (...) {
    std::cerr << "Sock Fatal Error : Unknown" << std::endl;
    fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
  }

  // Check data port connections
  bool outport_conn = check_dataPort_connections( m_OutPort );
  if (!outport_conn) {
    std::cerr << "### NO Connection" << std::endl;
    fatal_error_report(DATAPATH_DISCONNECTED);
  }

  return 0;
}

int SliTDaqmwReader1::daq_stop()
{
  std::cerr << "*** SliTDaqmwReader1::stop" << std::endl;

  if (m_sock) {
    m_sock->disconnect();
    delete m_sock;
    m_sock = 0;
  }

  return 0;
}

int SliTDaqmwReader1::daq_pause()
{
  std::cerr << "*** SliTDaqmwReader1::pause" << std::endl;
  
  return 0;
}

int SliTDaqmwReader1::daq_resume()
{
  std::cerr << "*** SliTDaqmwReader1::resume" << std::endl;
  
  return 0;
}

int SliTDaqmwReader1::create_buffer_ipaddress(){

  if( m_slitReader ) delete m_slitReader;
  if( m_slitBDF    ) delete m_slitBDF;
  m_slitReader = new SliTReader          (true, m_firmwareVersion);
  m_slitBDF    = new SliTBinaryDataFormat(      m_firmwareVersion);
  
  m_maxBuf     = m_slitBDF->getMaxBufferSize_byte();
  //m_srcAddr   = SliTSetup::getIpAddress( m_boardid ); // to be update.
  if( m_debug ) std::cerr << "   ip address : "<< m_srcAddr << std::endl;

  if( m_data ) delete m_data;
  m_data = new unsigned char[m_maxBuf];
 
  return 0;
}

void SliTDaqmwReader1::read_data_from_detectors()
{
  if( m_debug ) std::cerr << "*** SliTDaqmwReader1::read_data_from_detectors" << std::endl;
  /// write your logic here
  int status = 0;

  if( m_flReadHeader ){
    while(1){
      status = m_sock->readAll(&m_data[m_eventDataLength], m_slitBDF->getHeaderSize_byte());
      if( status == DAQMW::Sock::ERROR_FATAL ){
	std::cerr << "### ERROR: m_sock->readAll" << std::endl;
	fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
      }else if( status == DAQMW::Sock::ERROR_TIMEOUT ){
	if( m_isTimeOutFatal ){
	  std::cerr << "### Timeout: m_sock->readAll" << std::endl;
	  fatal_error_report(USER_DEFINED_ERROR3, "SOCKET TIMEOUT");
	  return;
	}else{
	  //std::cerr << "### NOT Timeout: m_sock->readAll" << std::endl;
	  return;
	}
      }else{
	break;
      }
    }

    // check header mark
    if( !m_slitBDF->isCorrectHeaderMark(&m_data[m_eventDataLength]) ){
      fprintf(stderr,"### ERROR: strange data format of header : %02x\n", (unsigned char)m_slitBDF->getHeaderMark(&m_data[m_eventDataLength]));
      fatal_error_report(USER_DEFINED_ERROR4, "WRONG DATA");
    }
    
    // check data length
    m_nData       = m_slitBDF->getNData          (&m_data[m_eventDataLength]);
    m_dataByte    = m_slitBDF->getDataLength_byte(&m_data[m_eventDataLength]);
    m_eventNumber = m_slitBDF->getEventNumber    (&m_data[m_eventDataLength]);
    m_isLastData  = m_slitBDF->isLastData        (&m_data[m_eventDataLength]);
    if( m_debug ){
      std::cout << "m_nData = "       << m_nData       << ", "
		<< "m_dataByte = "    << m_dataByte    << ", "
		<< "m_eventNumber = " << m_eventNumber << ", "
		<< "m_isLastData = "  << m_isLastData
		<< std::endl;
    }
    m_flReadHeader = false;
    m_eventDataLength += m_slitBDF->getHeaderSize_byte();
  }
  if( m_flReadHeader ) return;
  // read data and footer
  if( m_dataByte ){ // block read mode
    status = m_sock->readAll(&m_data[m_eventDataLength], m_dataByte + m_slitBDF->getFooterSize_byte());

    if( status == DAQMW::Sock::ERROR_FATAL ){
      std::cerr << "### ERROR: m_sock->readAll" << std::endl;
      fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
    }else if( status == DAQMW::Sock::ERROR_TIMEOUT ){
      if( m_isTimeOutFatal ){
	std::cerr << "### Timeout: m_sock->readAll" << std::endl;
	fatal_error_report(USER_DEFINED_ERROR3, "SOCKET TIMEOUT BETWEEN UNIT HEADER/DATA");
      }
    }else if( !m_slitBDF->isCorrectFooterMark(&m_data[m_eventDataLength+m_dataByte]) ){
      fprintf(stdout,"strange data format of footer : %0x2\n ", (unsigned char)m_slitBDF->getFooterMark(&m_data[m_eventDataLength+m_dataByte]));
      fatal_error_report(USER_DEFINED_ERROR4, "WRONG DATA");
    }else{
      m_eventDataLength += m_dataByte + m_slitBDF->getFooterSize_byte();
      m_flReadHeader     = true;
      m_flIsTimeOut      = false;
      m_flIsDetectFooter = true;
      if( m_isLastData ){
	m_cntIsLastData++;
	if( m_cntIsLastData==1 ){
	  if( m_cntIsLastData==m_nFooterPerEvent ){
	    m_flIsDetectEndOfEvent = true;
	    m_cntIsLastData        = 0;
	  }else if( m_prevEventNumber>0 && m_prevEventNumber==(int)m_eventNumber ){
	    std::cerr << "[ERROR] Wrong number of footer in an event : too much : " << m_prevEventNumber << " : " << (int)m_eventNumber << std::endl;
	    fatal_error_report(USER_DEFINED_ERROR5, "WRONG NUMBER OF FOTTER IN AN EVENT\n");
	  }
	}else{
	  if( m_prevEventNumber!=(int)m_eventNumber ){
	    std::cerr << "[ERROR] Wrong number of footer in an event : too few : " << m_prevEventNumber << " : " << (int)m_eventNumber << std::endl;
	    m_cntIsLastData = 1;
	    fatal_error_report(USER_DEFINED_ERROR5, "WRONG NUMBER OF FOTTER IN AN EVENT\n");
	  }
	  if( m_cntIsLastData==m_nFooterPerEvent ){
	    m_flIsDetectEndOfEvent = true;
	    m_cntIsLastData        = 0;
	  }
	}
	m_prevEventNumber = m_eventNumber;
      }
    }
  }else{ // search footer part in continuous readout mode	
    while(1){
      if( !m_flIsTimeOut ) status = m_sock->readAll(&m_data[m_eventDataLength], m_slitBDF->getOneHitDataSize_byte() );
      if( status == DAQMW::Sock::ERROR_FATAL ){
	std::cerr << "### ERROR: m_sock->readAll" << std::endl;
	fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
      }else if( status == DAQMW::Sock::ERROR_TIMEOUT ){
	if( m_isTimeOutFatal ){
	  std::cerr << "### Timeout: m_sock->readAll" << std::endl;
	  fatal_error_report(USER_DEFINED_ERROR3, "SOCKET TIMEOUT BETWEEN UNIT HEADER/DATA");
	}
      }else{
	if(m_slitBDF->isCorrectFooterMark(&m_data[m_eventDataLength]) ){ // find footer
	  m_eventDataLength += m_slitBDF->getOneHitDataSize_byte();
	  status = m_sock->readAll(&m_data[m_eventDataLength], m_slitBDF->getFooterSize_byte() - m_slitBDF->getOneHitDataSize_byte() ); // read the rest of footer
	  if( status == DAQMW::Sock::ERROR_FATAL ){
	    std::cerr << "### ERROR: m_sock->readAll" << std::endl;
	    fatal_error_report(USER_DEFINED_ERROR2, "SOCKET FATAL ERROR");
	  }else if( status == DAQMW::Sock::ERROR_TIMEOUT ){
	    if( m_isTimeOutFatal ){
	      std::cerr << "### Timeout: m_sock->readAll" << std::endl;
	      fatal_error_report(USER_DEFINED_ERROR3, "SOCKET TIMEOUT BETWEEN UNIT HEADER/DATA");
	    }else{
	      m_flIsTimeOut = true;
	    }
	  }else{
	    m_eventDataLength += m_slitBDF->getFooterSize_byte() - m_slitBDF->getOneHitDataSize_byte();
	    m_flReadHeader     = true;
	    m_flIsTimeOut      = false;
	    m_flIsDetectFooter = true;
	    if( m_isLastData ){
	      m_cntIsLastData++;
	      if( m_cntIsLastData==1 ){
		if( m_cntIsLastData==m_nFooterPerEvent ){
		  m_flIsDetectEndOfEvent = true;
		  m_cntIsLastData        = 0;
		}else if( m_prevEventNumber>0 && m_prevEventNumber==(int)m_eventNumber ){
		  std::cerr << "[ERROR] Wrong number of footer in an event : too much : " << m_prevEventNumber << " : " << (int)m_eventNumber << std::endl;
		  fatal_error_report(USER_DEFINED_ERROR5, "WRONG NUMBER OF FOTTER IN AN EVENT\n");
		}
	      }else{
		if( m_prevEventNumber!=(int)m_eventNumber ){
		  std::cerr << "[ERROR] Wrong number of footer in an event : too few : " << m_prevEventNumber << " : " << (int)m_eventNumber << std::endl;
		  m_cntIsLastData = 1;
		  fatal_error_report(USER_DEFINED_ERROR5, "WRONG NUMBER OF FOTTER IN AN EVENT\n");
		}
		if( m_cntIsLastData==m_nFooterPerEvent ){
		  m_flIsDetectEndOfEvent = true;
		  m_cntIsLastData        = 0;
		}
	      }
	      m_prevEventNumber = m_eventNumber;
	    }
	    break;
	  }
	}else{ // find data
	  m_eventDataLength += m_slitBDF->getOneHitDataSize_byte();
	}
      }
    }// end of while
  }

  if( m_debug ) std::cerr << "   data_length = "<< m_eventDataLength << std::endl;

  return;
}

int SliTDaqmwReader1::set_data(unsigned int data_byte_size)
{
  unsigned char header[HEADER_BYTE_SIZE];
  unsigned char footer[FOOTER_BYTE_SIZE];
  
  set_header(&header[0], data_byte_size);
  set_footer(&footer[0]);
  
  ///set OutPort buffer length
  m_out_data.data.length(data_byte_size + HEADER_BYTE_SIZE + FOOTER_BYTE_SIZE);
  memcpy( &(m_out_data.data[0]                                ), &header[0], HEADER_BYTE_SIZE );
  memcpy( &(m_out_data.data[HEADER_BYTE_SIZE]                 ), &m_data[0], data_byte_size   );
  memcpy( &(m_out_data.data[HEADER_BYTE_SIZE + data_byte_size]), &footer[0], FOOTER_BYTE_SIZE );
  
  return 0;
}

int SliTDaqmwReader1::write_OutPort()
{
  ////////////////// send data from OutPort  //////////////////
  bool ret = m_OutPort.write();

  //////////////////// check write status /////////////////////
  if( ret == false ){  // TIMEOUT or FATAL
    m_out_status  = check_outPort_status(m_OutPort);
    if     ( m_out_status == BUF_FATAL   ) fatal_error_report(OUTPORT_ERROR); // Fatal error
    else if( m_out_status == BUF_TIMEOUT ) return -1; // Timeout
  }else{ // successfully done
    m_out_status = BUF_SUCCESS;
  }
    
  return 0;
}

int SliTDaqmwReader1::daq_run()
{
  if( m_debug ) std::cerr << "*** SliTDaqmwReader1::run" << std::endl;

  if( check_trans_lock() ){ // check if stop command has come
    set_trans_unlock(); // transit to CONFIGURED state
    return 0;
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
  if( m_out_status == BUF_SUCCESS ){ // previous OutPort.write() successfully done
    read_data_from_detectors();
    if( m_eventDataLength==0 ) return 0;
    if( m_flIsDetectEndOfEvent || (!m_isStoreOneEventData && m_flIsDetectFooter) ){
      m_recvByteSize = m_eventDataLength;
      set_data(m_recvByteSize); // set data to OutPort Buffer	
    }else{
      return 0;
    }
  }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  if( m_flIsDetectEndOfEvent || (!m_isStoreOneEventData && m_flIsDetectFooter) ){
    if( m_debug ){
      std::cerr << "start to write : m_eventDataLength = " << m_eventDataLength << std::endl;
    }
    if( write_OutPort() < 0 ){ // Timeout. do nothing.
      ;     
    }else{ // OutPort write successfully done
      inc_sequence_num();                     // increase sequence num.
      inc_total_data_size(m_recvByteSize);  // increase total data byte size
      m_flIsDetectFooter = false;
      m_flIsDetectEndOfEvent = false;
      m_eventDataLength = 0;
    }
  }
    
  return 0;
}

extern "C"
{
  void SliTDaqmwReader1Init(RTC::Manager* manager)
  {
    RTC::Properties profile(slitdaqmwreader1_spec);
    manager->registerFactory(profile,
			     RTC::Create<SliTDaqmwReader1>,
			     RTC::Delete<SliTDaqmwReader1>);
  }
};
