function[obI] = getObiCellProps(obI)



cellIDs = obI.nameProps.cellNum;
checkIDs = unique(cellIDs(cellIDs>0));
cellCount = 0;
for i = 1:length(checkIDs)
    obIDs = find((cellIDs == checkIDs(i)) & obI.nameProps.ofID);
    mainID = intersect(obIDs,find(obI.nameProps.tag.cell));
    anyIDs =  find((cellIDs == checkIDs(i)) );
    
    if length(mainID)>1
        obI.nameProps.names(mainID)
        mainID
        'too many main IDs'
        mainID = mainID(1);
    elseif isempty(mainID)
        if ~isempty(obIDs)
            mainID = obIDs(1);
        else
            mainID = anyIDs(1);
        end
    end
    
    if ~isempty(mainID)
        cellCount = cellCount+1;
        obI.cell.obIDs{cellCount} = obIDs;
        obI.cell.name(cellCount) = checkIDs(i);
        obI.cell.mainID(cellCount) = mainID;
        obI.cell.label{cellCount} = obI.nameProps.names{mainID};
        obI.cell.anchors(cellCount,:) =  obI.colStruc.anchors(mainID,:);
    end
    
end